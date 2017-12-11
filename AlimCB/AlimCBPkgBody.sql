CREATE OR REPLACE PACKAGE BODY alimcb
AS
  PROCEDURE insert_movies AS
    line movie%rowtype;
    BEGIN
      SELECT
        id, title, original_title, status, release_date, vote_average, vote_count, certification,
        runtime, NULL
      --                         poster_path
      INTO line
      FROM movies_ext;
      INSERT INTO movie values line;
    END;
END alimcb;
/