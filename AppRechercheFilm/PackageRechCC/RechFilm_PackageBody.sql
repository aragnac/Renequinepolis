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
                           FROM utilisateur
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
      OPEN V_RefCursor FOR SELECT
                             id,
                             Title,
                             COALESCE(Release_Date, CURRENT_DATE) AS Release_Date,
                             Runtime,
                             vote_average,
                             vote_count,
                             poster
                           FROM movie
                             INNER JOIN MOVIE_POSTER ON MOVIE.ID = MOVIE_POSTER.MOVIE
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

  FUNCTION GetMovies(P_TITLE      IN movie.Title%TYPE, P_ACTORS IN NAMEARRAY,
                     P_DIRECTORS  IN NAMEARRAY, P_ANNEEAVANT IN VARCHAR2,
                     P_ANNEEAPRES IN VARCHAR2)
    RETURN SYS_REFCURSOR AS
    V_RefCursor SYS_REFCURSOR;
    BEGIN
      --Todo logs
      OPEN V_RefCursor FOR
      SELECT
        id,
        Title,
        COALESCE(Release_Date, CURRENT_DATE)
      FROM movie
      WHERE P_TITLE IS NULL
            OR
            UPPER(Title) LIKE UPPER('%' || P_TITLE || '%') -- Case insensitive
      INTERSECT
      SELECT
        id,
        Title,
        COALESCE(Release_Date, CURRENT_DATE)
      FROM movie
      WHERE P_ACTORS IS NULL
            OR
            id IN
            (
              SELECT MOVIE
              FROM ARTIST
                INNER JOIN MOVIE_ACTOR ACTOR ON ACTOR.ACTOR = ARTIST.ID
              WHERE UPPER(Name) IN (SELECT UPPER(column_value)
                                    FROM TABLE (P_ACTORS)) -- Case insensitive
            )
      INTERSECT
      SELECT
        id,
        Title,
        COALESCE(Release_Date, CURRENT_DATE)
      FROM movie
      WHERE P_DIRECTORS IS NULL
            OR
            id IN
            (
              SELECT movie
              FROM artist
                INNER JOIN MOVIE_DIRECTOR DIRECTOR ON ARTIST.ID = DIRECTOR.DIRECTOR
              WHERE UPPER(Name) = ALL (SELECT UPPER(column_value)
                                       FROM TABLE (P_DIRECTORS)) -- Case insensitive
            )
      INTERSECT
      SELECT
        id,
        Title,
        COALESCE(Release_Date, CURRENT_DATE)
      FROM movie
      WHERE
        (
          (P_ANNEEAVANT IS NULL AND P_ANNEEAPRES IS NULL)
          OR
          (
            (P_ANNEEAVANT IS NOT NULL AND P_ANNEEAPRES IS NOT NULL)
            AND
            (
              (P_ANNEEAPRES = P_ANNEEAVANT AND
               EXTRACT(YEAR FROM Release_date) = P_ANNEEAVANT)
              OR
              (P_ANNEEAPRES <> P_ANNEEAVANT AND EXTRACT(YEAR FROM
                                                        Release_date) BETWEEN P_ANNEEAPRES AND P_ANNEEAVANT)
            )
          )
          OR
          (
            (P_ANNEEAVANT IS NOT NULL AND P_ANNEEAPRES IS NULL)
            AND
            (EXTRACT(YEAR FROM Release_date) < P_ANNEEAVANT)
          )
          OR
          (
            (P_ANNEEAVANT IS NULL AND P_ANNEEAPRES IS NOT NULL)
            AND
            (EXTRACT(YEAR FROM Release_date) > P_ANNEEAPRES)
          )
        );

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
      OPEN V_RefCursor FOR SELECT
                             movie.id,
                             LISTAGG(Name, '; ')
                             WITHIN GROUP (
                               ORDER BY MOVIE.id, Name)
                           FROM ARTIST
                             INNER JOIN MOVIE_ACTOR ON ARTIST.ID = MOVIE_ACTOR.ACTOR
                             INNER JOIN movie ON movie.id = Movie_Actor.movie
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
      OPEN V_RefCursor FOR SELECT
                             movie.id,
                             LISTAGG(Name, '; ')
                             WITHIN GROUP (
                               ORDER BY movie.id, Name)
                           FROM ARTIST
                             INNER JOIN MOVIE_DIRECTOR ON ARTIST.ID = MOVIE_DIRECTOR.DIRECTOR
                             INNER JOIN Movie ON movie.id = MOVIE_DIRECTOR.MOVIE
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