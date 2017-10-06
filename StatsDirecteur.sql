CREATE TABLE tabl (
  idn    varchar2(10000),
  entree varchar2(10000)
);
PROMPT Directeurs
DECLARE
  maximum       number;
  mini          number;
  moyenne       number;
  mediane       number;
  ecart_type    number;
  nb_val        integer;
  nb_valnull    integer;
  nb_valnotnull integer;
  nb_valzero    integer;
  quant95       integer;
  dis           integer;
BEGIN
  INSERT INTO tabl (idn, entree)
    WITH temp (id, chaine, start_pos, end_pos) AS (
      SELECT
        id,
        directors,
        1,
        instr(directors, unistr('\2016'), 1)
      FROM movies_ext
      UNION ALL
      SELECT
        id,
        chaine,
        end_pos + 1,
        instr(chaine, unistr('\2016'), end_pos + 1)
      FROM temp
      WHERE end_pos != 0
    )
    SELECT
      (substr(substr(chaine, start_pos, (CASE WHEN end_pos = 0
        THEN length(chaine) + 1
                                         ELSE end_pos END) - start_pos), 1,
              instr(substr(chaine, start_pos, (CASE WHEN end_pos = 0
                THEN length(chaine) + 1
                                               ELSE end_pos END) - start_pos),unistr('\2024'), 1) - 1))                                               AS id,
      substr(substr(chaine, start_pos, (CASE WHEN end_pos = 0
        THEN length(chaine) + 1
                                        ELSE end_pos END) - start_pos),
             instr(substr(chaine, start_pos, (CASE WHEN end_pos = 0
               THEN length(chaine) + 1
                                              ELSE end_pos END) - start_pos), unistr('\2024'), 1) + 1,
             CASE WHEN end_pos = 0
               THEN length(chaine) + 1
             ELSE end_pos END
             - instr(substr(chaine, start_pos, (CASE WHEN end_pos = 0
               THEN length(chaine) + 1
                                                ELSE end_pos END) - start_pos), unistr('\2024'), 1) - 1) AS director
    FROM temp;

  SELECT
    min(length(entree))                  AS minimum,
    max(length(entree))                  AS maximum,
    median(length(entree))               AS medianne,
    round(stddev(length(entree)), 3)     AS ecart_type,
    count(length(entree))                AS nb_val,
    sum(CASE WHEN length(entree) IS NULL
      THEN 1
        ELSE 0 END)                      AS nb_valnull,
    sum(decode(length(entree), 0, 1, 0)) AS nb_valzero,
    percentile_cont(0.95)
    WITHIN GROUP (
      ORDER BY length(entree))           AS quant95,
    count(DISTINCT entree)               AS dis
  INTO mini, maximum, mediane, ecart_type, nb_val,
    nb_valnull, nb_valzero, quant95, dis
  FROM
    tabl;

  SELECT avg(length(entree)) AS moyenne
  INTO moyenne
  FROM tabl;

  INSERT INTO stats VALUES
    ('DIRECTOR.NAME', 'VARCHAR2', mini, maximum, moyenne, mediane, ecart_type, nb_val,
                   nb_valnull, abs(nb_val - nb_valnull), nb_valzero, quant95, dis);

  SELECT
    min(length(idn))                  AS minimum,
    max(length(idn))                  AS maximum,
    median(length(idn))               AS medianne,
    round(stddev(length(idn)), 3)     AS ecart_type,
    count(length(idn))                AS nb_val,
    sum(CASE WHEN length(idn) IS NULL
      THEN 1
        ELSE 0 END)                   AS nb_valnull,
    sum(decode(length(idn), 0, 1, 0)) AS nb_valzero,
    percentile_cont(0.95)
    WITHIN GROUP (
      ORDER BY length(idn))           AS quant95,
    count(DISTINCT idn)               AS dis
  INTO mini, maximum, mediane, ecart_type, nb_val,
    nb_valnull, nb_valzero, quant95, dis
  FROM
    tabl;

  SELECT avg(length(idn)) AS moyenne
  INTO moyenne
  FROM tabl;

  INSERT INTO stats VALUES
    ('DIRECTOR.ID', 'VARCHAR2', mini, maximum, moyenne, mediane, ecart_type, nb_val,
                 nb_valnull, abs(nb_val - nb_valnull), nb_valzero, quant95, dis);
  COMMIT;
END;
/
DROP TABLE tabl;