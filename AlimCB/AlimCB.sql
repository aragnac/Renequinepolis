DROP PACKAGE pkgAlim;
CREATE OR REPLACE PACKAGE pkgAlim AS

  /* Types */
  TYPE LIST_IDS_TEMP IS TABLE OF MOVIE.ID%TYPE INDEX BY PLS_INTEGER; -- list of ids
  TYPE LIST_MOVIES_TEMP IS TABLE OF movies_ext%ROWTYPE INDEX BY PLS_INTEGER;

  /* Methods */
  PROCEDURE alimRandom(n INTEGER);
  PROCEDURE alimCB_with_ids(ids LIST_IDS_TEMP);
  PROCEDURE addMovies(movieRow movies_ext%ROWTYPE);

  PROCEDURE addLogError(m logerror.message%TYPE);
  PROCEDURE addLogInfos(m loginfos.message%TYPE);

  PROCEDURE insertActor(line VARCHAR2, movieId MOVIE.ID%TYPE);
  PROCEDURE insertDirector(line VARCHAR2, movieId MOVIE.ID%TYPE);
  PROCEDURE insertGenre(line VARCHAR2, movieId MOVIE.ID%TYPE);
END pkgAlim;
/

CREATE OR REPLACE PACKAGE BODY pkgAlim AS
  /**************************************/
  /************* ADD LOGS ***************/
  /**************************************/
  PROCEDURE addLogError(m logerror.message%TYPE) AS
    --     PRAGMA AUTONOMOUS_TRANSACTION
    BEGIN
      INSERT INTO logerror VALUES (localtimestamp, NULL, m);
      COMMIT;
      EXCEPTION
      WHEN OTHERS THEN
      addLogError('addLogError : ' || SQLERRM);
      ROLLBACK;
    END;

  PROCEDURE addLogInfos(m loginfos.message%TYPE) AS
    BEGIN
      INSERT INTO loginfos VALUES (localtimestamp, m);
      COMMIT;
      EXCEPTION
      WHEN OTHERS THEN
      addLogError('addLogInfos : ' || SQLERRM);
      ROLLBACK;
    END;

  --Ajout du film dans la table Movie et ajout dans le log
  PROCEDURE ADDMOVIES(movieRow movies_ext%ROWTYPE)
  IS
      insert_error EXCEPTION;
  PRAGMA EXCEPTION_INIT (insert_error, -20010);
    newMovie MOVIE%ROWTYPE;
    poster   MOVIE_POSTER%ROWTYPE;
    temp     VARCHAR2(1000);
    BEGIN
      /* check fields for movie table */
      newMovie.ID := movieRow.ID;
      poster.MOVIE := movieRow.id;
      newMovie.RUNTIME := movieRow.RUNTIME;
      newMovie.RELEASE_DATE := movieRow.RELEASE_DATE;
      newMovie.VOTE_AVERAGE := movieRow.VOTE_AVERAGE;
      newMovie.VOTE_COUNT := movieRow.VOTE_COUNT;

      IF (newMovie.RUNTIME IS NOT NULL)
      THEN
        IF (newMovie.RELEASE_DATE IS NOT NULL)
        THEN
          temp := trim(movieRow.title);
          IF (lengthb(temp) >= 43)
          THEN
            addLogInfos(
                'Titre du film: ' || newMovie.id || ' est trop long. Nouvelle valeur: ' ||
                newMovie.TITLE || ' .');
            newMovie.title := substrb(temp, 1, 40) ||
                              '...'; -- Add ... when film title is too long
          ELSE
            newMovie.title := temp;
          END IF;

          temp := trim(movieRow.original_title);
          IF (lengthb(temp) >= 43)
          THEN
            addLogInfos(
                'Titre original du film: ' || newMovie.id || ' est trop long. Nouvelle valeur: ' ||
                newMovie.ORIGINAL_TITLE ||
                ' .');
            newMovie.original_title := substrb(temp, 1, 40) || '...';
          ELSE
            newMovie.ORIGINAL_TITLE := temp;
          END IF;

          IF (movieRow.status IS NOT NULL)
          THEN
            IF (movieRow.STATUS IN
                ('Post Production', 'Rumored', 'Released', 'In Production', 'Planned', 'Canceled'))
            THEN
              newMovie.status := initcap(lower(movieRow.status));
            ELSE
              newMovie.STATUS := NULL;
              addLogError('Vérif status: valueur inconnue. Mise à null.');
            END IF;
          END IF;

          IF (movieRow.certification IS NOT NULL)
          THEN
            IF (movieRow.CERTIFICATION IN ('G', 'PG', 'PG-13', 'R', 'NC-17'))
            THEN
              newMovie.certification := upper(movieRow.certification);
            ELSE
              newMovie.CERTIFICATION := NULL;
              addLogError('Vérif certification: valeur inconnue. Mise à null.');
            END IF;
          END IF;

          -- get the blob from the poster_path
          BEGIN
            IF (movieRow.poster_path IS NOT NULL)
            THEN
              poster.POSTER := httpuritype.createuri(
                  'http://image.tmdb.org/t/p/w185' || movieRow.poster_path).getblob();
            END IF;
            EXCEPTION WHEN OTHERS THEN
            poster.POSTER := empty_blob();
            addLogInfos('Blob poster: Impossible de récupèrer le blob du film ' || movieRow.id ||
                        '. nouveau blob: empty_blob.');
          END;

          -- Inserting the movie
          SAVEPOINT before_insert;
          INSERT INTO cb.movie VALUES newMovie;
          addLogInfos(
              'Le film ' || newMovie.title || '(' || newMovie.id || ') a été correctement ajouté.');
          INSERT INTO cb.MOVIE_POSTER VALUES poster;
          addLogInfos('Le poster du film ' || newMovie.title || '(' || newMovie.id ||
                      ') a été correctement ajouté.');
          -- Inserting the composite fields
          insertActor(movieRow.actors, newMovie.id);
          insertDirector(movieRow.directors, newMovie.id);
          insertGenre(movieRow.genres, newMovie.id);
          COMMIT;
        END IF;
      END IF;
      EXCEPTION

      WHEN DUP_VAL_ON_INDEX THEN
      addLogError('L''id ' || newMovie.id || ' est déjà existant.');
      ROLLBACK TO before_insert;

      WHEN OTHERS THEN
      raise_application_error(-20010,
                              'Exception à l''insertion: ' || newMovie.id || '(' || newMovie.TITLE
                              || '). ' || chr(10) ||
                              'Cause: ' || SQLERRM || chr(10) ||
                              DBMS_UTILITY.format_error_backtrace);
      ROLLBACK TO before_insert;

    END addMovies;

  /**************************************************************************************************************/

  PROCEDURE alimRandom(n INTEGER) IS
    list_movies LIST_MOVIES_TEMP;
    BEGIN
      -- Checking n (number)
      IF (n <= 0)
      THEN
        addLogInfos('Paramètre incorrect: NULL or val < 0');
      END IF;

      -- Collecting the movies
      WITH rand AS (
          SELECT *
          FROM movies_ext
          WHERE id NOT IN (SELECT id
                           FROM movie)
          ORDER BY dbms_random.value
      )
      SELECT *
      BULK COLLECT INTO list_movies
      FROM rand
      WHERE rownum <= n;

      IF (list_movies.count < n)
      THEN
        addLogInfos('Ajout de films aléatoires: il n'' a pas suffisament de films trouvés');
      END IF;

      -- Adding movies
      FOR i IN list_movies.first .. list_movies.last LOOP
        addMovies(list_movies(i));
      END LOOP;

      EXCEPTION
      WHEN OTHERS THEN
      addLogError('Ajout films aléatoires: ' || SQLERRM || '  ' || SQLCODE);
      RAISE;

    END alimRandom;
  /***********************************************************************************************************/

  -- Alimentation CB avec liste ID précis
  PROCEDURE alimCB_with_ids(ids LIST_IDS_TEMP) IS
    list_movies LIST_MOVIES_TEMP;
    BEGIN
      -- Checking parameter
      IF (ids IS NULL OR ids.count < 1)
      THEN
        addLogError('Ajout avec id: paramètre "ids" null ou vide.');
      END IF;

      -- Collecting the movies
      SELECT *
      BULK COLLECT INTO list_movies
      FROM movies_ext
      WHERE id IN (SELECT *
                   FROM TABLE (ids));

      -- Checking the results
      IF (list_movies.count < ids.count)
      THEN
        addLogError('Ajout avec id: id du film introuvable.');
      ELSIF (list_movies.count > ids.count)
        THEN
          addLogInfos('Ajout avec id: trop de films trouvés. Il y a une incohérence dans la base CI.');
      END IF;

      -- Processing the movies
      FOR i IN list_movies.first .. list_movies.last LOOP
        addMovies(list_movies(i));
      END LOOP;

      EXCEPTION
      WHEN OTHERS THEN
      addLogError('Ajout avec id: ' || SQLERRM || '-' || SQLCODE);
      RAISE;

    END alimCB_with_ids;

  PROCEDURE insertActor(line VARCHAR2, movieId MOVIE.ID%TYPE) IS
    id       INTEGER;
    name     VARCHAR2(200);
    i        NUMBER := 1;
    doInsert BOOLEAN := TRUE;
    BEGIN
      LOOP
        -- extraction
        id := TO_NUMBER(REGEXP_SUBSTR(line, '(‖|^)(\d+)․', 1, i, NULL, 2));
        name := trim(REGEXP_SUBSTR(line, '․([^․‖]+)․', 1, i, NULL, 1));
        EXIT WHEN id IS NULL;

        IF (lengthb(name) > 20)
        THEN
          name := substrb(name, 1, 17) || '...';
          addLogInfos('InsereActeur: ' || id || ' tronqué.');
        END IF;

        -- actor
        doInsert := TRUE;
        SAVEPOINT before_actor;
        BEGIN
          INSERT INTO artist (id, name) VALUES (id, name);
          addLogInfos('InsereActeur: ' || id || ' ajouté.');
          EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN
          ROLLBACK TO before_actor;
          addLogInfos('InsereActeur: ' || id || ' existe.');
          WHEN OTHERS THEN
          ROLLBACK TO before_actor;
          addLogError('InsereActeur: ' || id || '. Exception: ' || SQLERRM || ' - ' || SQLCODE);
          doInsert := FALSE;
        END;

        -- si OK ou acteur déjà présent pour quand meme faire le lien
        -- movie_actor
        SAVEPOINT before_link_actor;
        IF (doInsert = TRUE)
        THEN
          BEGIN
            INSERT INTO movie_actor (movie, ACTOR) VALUES (movieId, id);
            addLogInfos('Lien entre le film: ' || movieId || ' et l''acteur: ' || id || ' ajouté.');
            EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK TO before_link_actor;
--             addLogInfos('Lien entre le film: ' || movieId || ' et l''acteur: ' || id || ' est déjà existant.');
            WHEN OTHERS THEN
            ROLLBACK TO before_link_actor;
            addLogError(
                'Lien entre le film: ' || movieId || ' et l''acteur: ' || id || ': Exception:'
                || SQLERRM || ' - ' || SQLCODE);
          END;
        END IF;
        i := i + 1;
      END LOOP;
    END insertActor;

  PROCEDURE insertDirector(line VARCHAR2, movieId MOVIE.ID%TYPE) IS
    id       INTEGER;
    name     VARCHAR2(200);
    i        NUMBER := 1;
    doInsert BOOLEAN := TRUE;
    BEGIN

      LOOP
        -- extraction
        id := TO_NUMBER(REGEXP_SUBSTR(line, '(‖|^)(\d+)․', 1, i, NULL, 2));
        name := trim(REGEXP_SUBSTR(line, '․([^․‖]+)․', 1, i + 1));
        EXIT WHEN id IS NULL;

        IF (lengthb(name) > 20)
        THEN
          name := substrb(name, 1, 17) || '...';
          addLogInfos('Directeur: ' || id || ' tronqué.');
        END IF;

        -- director
        doInsert := TRUE;
        SAVEPOINT before_director;
        BEGIN
          INSERT INTO artist (id, name) VALUES (id, name);
          addLogInfos('Directeur: ' || id || ' ajouté.');
          EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN
          ROLLBACK TO before_director;
--           addLogInfos('Directeur: ' || id || ' existe déjà.');
          WHEN OTHERS THEN
          ROLLBACK TO before_director;
          addLogInfos('Directeur: ' || id || '. Exception: ' || SQLERRM || ' - ' || SQLCODE);
          doInsert := FALSE;
        END;

        -- movie_director
        SAVEPOINT before_link_director;
        IF (doInsert = TRUE)
        THEN
          BEGIN
            INSERT INTO movie_director (movie, DIRECTOR) VALUES (movieId, id);
            addLogInfos(
                'Lien entre le film: ' || movieId || ' et le directeur: ' || id || ' ajouté.');
            EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK TO before_link_director;
--             addLogInfos('Lien entre le film: ' || movieId || ' et le directeur: ' || id || ' déjà existant.');
            WHEN OTHERS THEN
            ROLLBACK TO before_link_director;
            addLogError(
                'Lien entre le film: ' || movieId || ' and director: ' || id || ': Exception: '
                || SQLERRM || ' - ' || SQLCODE);
          END;
        END IF;

        i := i + 2;
      END LOOP;
    END insertDirector;

  PROCEDURE insertGenre(line VARCHAR2, movieId MOVIE.ID%TYPE) IS
    id       INTEGER;
    name     VARCHAR2(200);
    i        NUMBER := 1;
    doInsert BOOLEAN := TRUE;

    BEGIN
      LOOP
        --extraction
        id := TO_NUMBER(REGEXP_SUBSTR(line, '[^․‖]+', 1, i));
        name := trim(REGEXP_SUBSTR(line, '[^․‖]+', 1, i + 1));
        EXIT WHEN id IS NULL;

        -- genre
        doInsert := TRUE;
        SAVEPOINT before_genre;
        BEGIN
          INSERT INTO genre (id, name) VALUES (id, name);
          addLogInfos('Genre: ' || id || ' inserer.');
          EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN
          ROLLBACK TO before_genre;
--           addLogInfos('Genre: ' || id || ' existe déjà.');
          WHEN OTHERS THEN
          ROLLBACK TO before_genre;
          addLogError('Genre: ' || id || '. Exception: ' || SQLERRM || ' - ' || SQLCODE);
          doInsert := FALSE;
        END;

        -- movie_genre
        SAVEPOINT before_link_genre;
        IF (doInsert = TRUE)
        THEN
          BEGIN
            INSERT INTO movie_genre (movie, genre) VALUES (movieId, id);
            addLogInfos('Lien entre le film: ' || movieId || ' et le genre: ' || id || ' ajouté.');
            EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK TO before_link_genre;
--             addLogInfos('Lien entre le film: ' || movieId || ' et le genre: ' || id || ' existe déjà.');
            WHEN OTHERS THEN
            ROLLBACK TO before_link_genre;
            addLogError(
                'Lien entre le film: ' || movieId || ' et le genre: ' || id || ': ' ||
                SQLERRM || ' - ' || SQLCODE);
          END;
        END IF;

        i := i + 2;
      END LOOP;
    END insertGenre;


END;