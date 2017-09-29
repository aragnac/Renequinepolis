--54768․Turo Pajala․Taisto Olavi Kasurinen‖54769․Susanna Haavisto․Irmeli Katariina Pihlaja‖4826․Matti Pellonpää․Mikkonen‖54770․Eetu Hilkamo․Riku
DECLARE
  maximum       NUMBER;
  mini          NUMBER;
  moyenne       NUMBER;
  mediane       NUMBER;
  ecart_type    NUMBER;
  nb_val        INTEGER;
  nb_valnull    INTEGER;
  nb_valnotnull INTEGER;
  nb_valzero    INTEGER;
  quant95       INTEGER;
  dis           INTEGER;
BEGIN
  SELECT
    min(length(acteur))                  AS minimum,
    max(length(acteur))                  AS maximum,
    avg(length(acteur))                  AS moyenne,
    median(length(acteur))               AS medianne,
    round(stddev(length(acteur)), 3)     AS ecart_type,
    count(length(acteur))                AS nb_val,
    sum(CASE WHEN length(acteur) IS NULL
      THEN 1
        ELSE 0 END)                      AS nb_valnull,
    sum(decode(length(acteur), 0, 1, 0)) AS nb_valzero,
    percentile_cont(0.95)
    WITHIN GROUP (
      ORDER BY length(acteur))           AS quant95,
    count(DISTINCT acteur)               AS dis

  INTO mini, maximum, moyenne, mediane, ecart_type, nb_val, nb_valnull, nb_valzero, quant95, dis

  FROM
    (
      WITH temp ( ID, chaine, start_pos, end_pos) AS (
        SELECT
          ID,
          ACTORS,
          1,
          instr(ACTORS, '‖', 1)
        FROM MOVIES_EXT
        WHERE ACTORS IS NOT NULL
        UNION ALL
        SELECT
          ID,
          chaine,
          end_pos + 1,
          instr(chaine, '‖', end_pos + 1)
        FROM temp
        WHERE end_pos != 0
      )
      SELECT
        substr(substr(chaine, start_pos, (CASE WHEN end_pos = 0
          THEN length(chaine) + 1
                                          ELSE end_pos END) - start_pos), 1,
               instr(substr(chaine, start_pos, (CASE WHEN end_pos = 0
                 THEN length(chaine) + 1
                                                ELSE end_pos END) - start_pos), '․', 1) - 1) AS id,
        substr(substr(chaine, start_pos, (CASE WHEN end_pos = 0
          THEN length(chaine) + 1
                                          ELSE end_pos END) - start_pos)
        , instr(substr(chaine, start_pos, (CASE WHEN end_pos = 0
          THEN length(chaine) + 1
                                           ELSE end_pos END) - start_pos)
        , '․', 1) + 1, instr(substr(substr(chaine, start_pos, (CASE WHEN end_pos = 0
          THEN length(chaine) + 1
                                                               ELSE end_pos END) - start_pos)
        , instr(substr(chaine, start_pos, (CASE WHEN end_pos = 0
          THEN length(chaine) + 1
                                           ELSE end_pos END) - start_pos)
        , '․', 1) + 1), '․') - 1)
                                                                                             AS acteur
      FROM temp);
  INSERT INTO stats VALUES
    ('ACTEURS', 'VARCHAR2', mini, maximum, moyenne, mediane, ecart_type, nb_val, nb_valnull,
                nb_valzero, quant95, dis);
  COMMIT;
END;