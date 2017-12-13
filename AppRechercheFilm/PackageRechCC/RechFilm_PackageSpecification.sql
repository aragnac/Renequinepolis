CREATE OR REPLACE TYPE NAMEARRAY IS TABLE OF VARCHAR2(37);
CREATE OR REPLACE PACKAGE RechFilm AS
  FUNCTION Connexion(P_LOGIN IN utilisateur.Login%TYPE)
    RETURN SYS_REFCURSOR;
  FUNCTION GetMovie(P_IDMOVIE IN movie.id%TYPE)
    RETURN SYS_REFCURSOR;
  FUNCTION GetMovies(P_TITLE      IN movie.Title%TYPE, P_ACTORS IN NAMEARRAY,
                     P_DIRECTORS  IN NAMEARRAY, P_ANNEEAVANT IN VARCHAR2,
                     P_ANNEEAPRES IN VARCHAR2)
    RETURN SYS_REFCURSOR;
  FUNCTION GetActorsFromMovie(P_IDMOVIE IN movie.id%TYPE)
    RETURN SYS_REFCURSOR;
  FUNCTION GetDirectorsFromMovie(P_IDMOVIE IN movie.id%TYPE)
    RETURN SYS_REFCURSOR;

  PROCEDURE addLogError(m logerror.message%TYPE);
  PROCEDURE addLogInfos(m loginfos.message%TYPE);
  --   FUNCTION GetPoster(P_IDPOSTER IN MOVIE_POSTER.movie%TYPE)  RETURN SYS_REFCURSOR;
  --   FUNCTION GetQuotationsOpinionsFromRQS(P_IDMOVIE IN movie.id%TYPE) RETURN SYS_REFCURSOR;
  --   FUNCTION GetQuotationsOpinionsFromRQS(P_IDMOVIE IN movie.id%TYPE, P_PAGE IN INTEGER) RETURN SYS_REFCURSOR;
END RechFilm;