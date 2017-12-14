CREATE OR REPLACE PACKAGE BODY RechFilm AS
  /****************************************************************************************************************************************/

  ------------ Connexion ------------------------------------------------------------
  -- *** IN : Un Users.Login%TYPE
  -- *** OUT : SYS_REFCURSOR
  -- *** PROCESS : Récupère les informations du login passé en paramètre
  ---------------------------------------------------------------------------------------------------------

  FUNCTION Connexion(P_LOGIN IN utilisateur.Login%TYPE)
    RETURN SYS_REFCURSOR AS
    V_RefCursor SYS_REFCURSOR;
    BEGIN
      --todo logs
      OPEN V_RefCursor FOR SELECT Password
                           FROM utilisateur@cctocb
                           WHERE Login = P_LOGIN;

      RETURN V_RefCursor;
      EXCEPTION
      WHEN OTHERS THEN
      IF (V_RefCursor%ISOPEN)
      THEN
        CLOSE V_RefCursor;
      END IF;
      --todo logs;
      RETURN NULL;
    END Connexion;

  /****************************************************************************************************************************************/

  ------------ GetMovie ------------------------------------------------------------
  -- *** IN : Movies.idMovie%TYPE
  -- *** OUT : SYS_REFCURSOR
  -- *** PROCESS : Récupère les informations du film dont l'identifiant est passé en paramètre
  ---------------------------------------------------------------------------------------------------------

  FUNCTION GetMovie(P_IDMOVIE IN movie.id%TYPE)
    RETURN SYS_REFCURSOR AS
    V_RefCursor SYS_REFCURSOR;
    BEGIN
      --todo logs
      OPEN V_RefCursor FOR SELECT id, Title, COALESCE(Release_Date, CURRENT_DATE) AS Release_Date
                           FROM movie@cctocb
                           WHERE id = P_IDMOVIE;

      RETURN V_RefCursor;
      EXCEPTION
      WHEN OTHERS THEN
      IF (V_RefCursor%ISOPEN)
      THEN
        CLOSE V_RefCursor;
      END IF;
      --todo logs
      RETURN NULL;
    END GetMovie;

  PROCEDURE GetMovieDetails(P_IDMOVIE IN movie.id%TYPE, P_DETAILS OUT SYS_REFCURSOR,
                            P_ACTOR OUT SYS_REFCURSOR, P_DIRECTOR OUT SYS_REFCURSOR,
                            P_GENRE OUT SYS_REFCURSOR)
  AS
    BEGIN
      OPEN P_DETAILS FOR
      SELECT m.*,mp.poster
      FROM MOVIE@cctocb m
        INNER JOIN MOVIE_POSTER@cctocb mp ON m.id = mp.movie
      WHERE id = P_IDMOVIE;

      OPEN P_ACTOR FOR
      SELECT a.NAME
      FROM ARTIST@cctocb a INNER JOIN MOVIE_ACTOR@cctocb ma ON a.id = ma.ACTOR
      WHERE ma.MOVIE = P_IDMOVIE;

      OPEN P_DIRECTOR FOR
      SELECT a.NAME
      FROM ARTIST@cctocb a INNER JOIN MOVIE_DIRECTOR@cctocb md ON a.id = md.director
      WHERE md.MOVIE = P_IDMOVIE;

      OPEN P_GENRE FOR
      SELECT g.NAME
      FROM GENRE@cctocb g INNER JOIN MOVIE_GENRE@cctocb mg ON g.id = mg.genre
      WHERE mg.movie = P_IDMOVIE;
    END;

  FUNCTION GetMovies(P_TITLE     IN movie.Title%TYPE, P_ACTORS IN NAMEARRAY,
                     P_DIRECTORS IN NAMEARRAY, P_ANNEE IN VARCHAR2)
    RETURN SYS_REFCURSOR AS
    V_RefCursor SYS_REFCURSOR;
    BEGIN
      --Todo logs
      OPEN V_RefCursor FOR
      SELECT id, Title, COALESCE(Release_Date, CURRENT_DATE)
      FROM movie@cctocb
      WHERE P_TITLE IS NULL
            OR
            UPPER(Title) LIKE UPPER('%' || P_TITLE || '%') -- Case insensitive
      INTERSECT
      SELECT id, Title, COALESCE(Release_Date, CURRENT_DATE)
      FROM movie@cctocb
      WHERE P_ACTORS IS NULL
            OR
            id IN
            (
              SELECT movie
              FROM ARTIST@cctocb
                INNER JOIN MOVIE_ACTOR@cctocb A2 ON ARTIST.ID = A2.ACTOR
              WHERE upper(name) IN (SELECT upper(COLUMN_VALUE)
                                    FROM TABLE (P_ACTORS))
              GROUP BY movie
              HAVING count(movie) >= (SELECT count(COLUMN_VALUE)
                                      FROM TABLE (P_ACTORS)))
      INTERSECT
      SELECT id, Title, COALESCE(Release_Date, CURRENT_DATE)
      FROM movie@cctocb
      WHERE P_DIRECTORS IS NULL
            OR
            id IN
            (
              SELECT movie
              FROM ARTIST@cctocb
                INNER JOIN MOVIE_DIRECTOR@cctocb A2 ON ARTIST.ID = A2.DIRECTOR
              WHERE upper(name) IN (SELECT upper(COLUMN_VALUE)
                                    FROM TABLE (P_DIRECTORS))
              GROUP BY movie
              HAVING count(movie) >= (SELECT count(COLUMN_VALUE)
                                      FROM TABLE (P_DIRECTORS)) -- Case insensitive
            )
      INTERSECT
      SELECT id, Title, COALESCE(Release_Date, CURRENT_DATE)
      FROM movie@cctocb
      WHERE P_ANNEE IS NULL
            OR P_ANNEE = EXTRACT(YEAR FROM Release_date)
      ORDER BY id;
      RETURN V_RefCursor;

      EXCEPTION
      WHEN OTHERS THEN
      IF (V_RefCursor%ISOPEN)
      THEN
        CLOSE V_RefCursor;
      END IF;
      -- todo logs
      RETURN NULL;
    END GetMovies;

  FUNCTION GetActorsFromMovie(P_IDMOVIE IN movie.id%TYPE)
    RETURN SYS_REFCURSOR AS
    V_RefCursor SYS_REFCURSOR;
    BEGIN
      -- todo logs
      OPEN V_RefCursor FOR SELECT movie.id, LISTAGG(Name, '; ')
      WITHIN GROUP (
        ORDER BY MOVIE.id, Name)
                           FROM ARTIST@cctocb
                             INNER JOIN MOVIE_ACTOR@cctocb ON ARTIST.ID = MOVIE_ACTOR.ACTOR
                             INNER JOIN movie@cctocb ON movie.id = Movie_Actor.movie
                           WHERE movie.id = P_IDMOVIE
                           GROUP BY movie.id
                           ORDER BY movie.id;

      RETURN V_RefCursor;
      EXCEPTION
      WHEN OTHERS THEN
      IF (V_RefCursor%ISOPEN)
      THEN
        CLOSE V_RefCursor;
      END IF;
      --todo logs
      RETURN NULL;
    END GetActorsFromMovie;

  FUNCTION GetDirectorsFromMovie(P_IDMOVIE IN movie.id%TYPE)
    RETURN SYS_REFCURSOR AS
    V_RefCursor SYS_REFCURSOR;
    BEGIN
      --todo logs
      OPEN V_RefCursor FOR SELECT movie.id, LISTAGG(Name, '; ')
      WITHIN GROUP (
        ORDER BY movie.id, Name)
                           FROM ARTIST@cctocb
                             INNER JOIN MOVIE_DIRECTOR@cctocb ON ARTIST.ID = MOVIE_DIRECTOR.DIRECTOR
                             INNER JOIN Movie@cctocb ON movie.id = MOVIE_DIRECTOR.MOVIE
                           WHERE movie.id = P_IDMOVIE
                           GROUP BY movie.id
                           ORDER BY movie.id;
      RETURN V_RefCursor;
      EXCEPTION
      WHEN OTHERS THEN
      IF (V_RefCursor%ISOPEN)
      THEN
        CLOSE V_RefCursor;
      END IF;
      -- todo logs
      RETURN NULL;
    END GetDirectorsFromMovie;

  --   FUNCTION GetQuotationsOpinionsFromRQS(P_IDMOVIE IN movie.id%TYPE)
  --     RETURN SYS_REFCURSOR AS
  --     V_RefCursor SYS_REFCURSOR;
  --     BEGIN
  --       --todo logs
  --       OPEN V_RefCursor FOR SELECT
  --                              ROUND(COALESCE(AVG(Quotation), 0), 2),
  --                              COUNT(Quotation),
  --                              COUNT(*)
  --                            FROM QuotationsOpinions
  --                            WHERE idMovie = P_IDMOVIE;
  --
  --       RETURN V_RefCursor;
  --       EXCEPTION
  --       WHEN OTHERS THEN
  --       IF (V_RefCursor%ISOPEN)
  --       THEN
  --         CLOSE V_RefCursor;
  --       END IF;
  --       --todo logs
  --       RETURN NULL;
  --     END GetQuotationsOpinionsFromRQS;

  --   FUNCTION GetQuotationsOpinionsFromRQS(P_IDMOVIE IN movie.id%TYPE, P_PAGE IN INTEGER)
  --     RETURN SYS_REFCURSOR AS
  --     V_RefCursor SYS_REFCURSOR;
  --     BEGIN
  --       --todo logs
  --       OPEN V_RefCursor FOR SELECT
  --                              login,
  --                              quotation,
  --                              opinion,
  --                              dateOfPost
  --                            FROM
  --                              (
  --                                SELECT
  --                                  QuotationsOpinions.*,
  --                                  ROW_NUMBER()
  --                                  OVER (
  --                                    ORDER BY 1 ) R
  --                                FROM QuotationsOpinions
  --                                WHERE IdMovie = P_IDMOVIE
  --                              )
  --                            WHERE R BETWEEN (5 * P_PAGE) + 1 AND ((5 * P_PAGE) + 5);
  --
  --       RETURN V_RefCursor;
  --       EXCEPTION
  --       WHEN OTHERS THEN
  --       IF (V_RefCursor%ISOPEN)
  --       THEN
  --         CLOSE V_RefCursor;
  --       END IF;
  --       --todo logs
  --       RETURN NULL;
  --     END GetQuotationsOpinionsFromRQS;
END RechFilm;