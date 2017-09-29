DECLARE
  maximum       NUMBER;
  mini          NUMBER;
  moyenne       NUMBER;
  mediane       NUMBER;
  ecart_type    NUMBER;
  nb_Val        INTEGER;
  nb_ValNull    INTEGER;
  nb_ValNotNull INTEGER;
  nb_ValZero    INTEGER;
  quant95       INTEGER;
  dis           INTEGER;
BEGIN
  SELECT
    min(length(DIRECTOR))                  AS minimum,
    max(length(DIRECTOR))                  AS maximum,
    avg(length(DIRECTOR))                  AS moyenne,
    median(length(DIRECTOR))               AS medianne,
    round(stddev(length(DIRECTOR)), 3)     AS ecart_type,
    count(length(DIRECTOR))                AS nb_Val,
    sum(CASE WHEN length(DIRECTOR) IS NULL
      THEN 1
        ELSE 0 END)                        AS nb_ValNull,
    sum(decode(length(DIRECTOR), 0, 1, 0)) AS nb_ValZero,
    percentile_cont(0.95)
    WITHIN GROUP (
      ORDER BY length(DIRECTOR))           AS quant95,
    count(DISTINCT DIRECTOR)               AS dis

  INTO mini, maximum, moyenne, mediane, ecart_type, nb_Val, nb_ValNull, nb_ValZero, quant95, dis

  FROM
    (
      WITH temp (id, chaine, start_pos, end_pos) AS (
        SELECT
          id,
          DIRECTORS,
          1,
          instr(DIRECTORS, '‖', 1)
        FROM movies_ext
        WHERE DIRECTORS IS NOT NULL
        UNION ALL
        SELECT
          id,
          chaine,
          end_pos + 1,
          instr(chaine, '‖', end_pos + 1)
        FROM temp
        WHERE end_pos != 0
      )
      SELECT DISTINCT
        substr(substr(chaine, start_pos, (CASE WHEN end_pos = 0
          THEN length(chaine) + 1
                                          ELSE end_pos END) - start_pos), 1,
               instr(substr(chaine, start_pos, (CASE WHEN end_pos = 0
                 THEN length(chaine) + 1
                                                ELSE end_pos END) - start_pos), '․', 1) - 1)   AS ID,
        substr(substr(chaine, start_pos, (CASE WHEN end_pos = 0
          THEN length(chaine) + 1
                                          ELSE end_pos END) - start_pos),
               instr(substr(chaine, start_pos, (CASE WHEN end_pos = 0
                 THEN length(chaine) + 1
                                                ELSE end_pos END) - start_pos), '․', 1) + 1,
               CASE WHEN end_pos = 0
                 THEN length(chaine) + 1
               ELSE end_pos END
               - instr(substr(chaine, start_pos, (CASE WHEN end_pos = 0
                 THEN length(chaine) + 1
                                                  ELSE end_pos END) - start_pos), '․', 1) - 1) AS DIRECTOR
      FROM temp
    );
  INSERT INTO stats VALUES
    ('DIRECTOR', 'VARCHAR2', mini, maximum, moyenne, mediane, ecart_type, nb_val, nb_valnull,
                 nb_valzero, quant95, dis);
  COMMIT;
END;