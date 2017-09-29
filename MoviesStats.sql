DECLARE
  strquerry  VARCHAR2(1000);
  numquerry  VARCHAR2(1000);
  maximum    NUMBER;
  mini       NUMBER;
  moyenne    NUMBER;
  mediane    NUMBER;
  ecart_type NUMBER;
  nb_val     INTEGER;
  nb_valnull INTEGER;
  nb_valzero INTEGER;
  quant95    INTEGER := NULL;
  dis        INTEGER;
BEGIN
  FOR col_name IN (SELECT
                     column_name,
                     data_type
                   FROM user_tab_columns
                   WHERE
                     table_name = 'MOVIES_EXT' AND column_name != 'ACTORS' AND column_name != 'GENRES' AND
                     column_name != 'DIRECTORS')
  LOOP

    IF col_name.data_type = 'VARCHAR2'
    THEN
      strquerry := 'select min(length(' || col_name.column_name || ')) as minimum, ' ||
                   'max(length(' || col_name.column_name || ')) as maximum, ' ||
                   'round(avg(length(' || col_name.column_name || ')), 3) as moyenne, ' ||
                   'median(length(' || col_name.column_name || ')) as medianne, ' ||
                   'round(stddev(length(' || col_name.column_name || ')), 3) as ecart_type, ' ||
                   'count(length(' || col_name.column_name || ')) as nb_Val, ' ||
                   'sum(case when length(' || col_name.column_name || ') is null then 1 else 0 end) as nb_ValNull, ' ||
                   'sum(decode(length(' || col_name.column_name || ') , 0, 1, 0)) as nb_ValZero, ' ||
                   'percentile_cont(0.95) within group (order by length(' || col_name.column_name || ')) as quant99,' ||
                   'count(distinct ' || col_name.column_name || ') as distvalues ' ||
                   'from movies_ext';

      EXECUTE IMMEDIATE strquerry INTO mini, maximum, moyenne, mediane, ecart_type, nb_val, nb_valnull, nb_valzero, quant95, dis;

      INSERT INTO stats VALUES
        (col_name.column_name, col_name.data_type, mini, maximum, moyenne, mediane, ecart_type, nb_val, nb_valnull,
                               nb_valzero, quant95, dis);

    ELSIF col_name.data_type = 'NUMBER'
      THEN
        numquerry := 'select min(' || col_name.column_name || ') as minimum, ' ||
                     'max(' || col_name.column_name || ') as maximum, ' ||
                     'round(avg(' || col_name.column_name || '), 3) as moyenne, ' ||
                     'median(' || col_name.column_name || ') as medianne, ' ||
                     'round(stddev(' || col_name.column_name || '), 3) as ecart_type, ' ||
                     'count(' || col_name.column_name || ') as nb_Val, ' ||
                     'sum(case when ' || col_name.column_name || ' is null then 1 else 0 end) as nb_ValNull, ' ||
                     'sum(decode(' || col_name.column_name || ' , 0, 1, 0)) as nb_ValZero,' ||
                     'count(distinct ' || col_name.column_name || ') as distvalues ' ||
                     'from movies_ext';

        EXECUTE IMMEDIATE numquerry INTO mini, maximum, moyenne, mediane, ecart_type, nb_val, nb_valnull, nb_valzero, dis;

        quant95 := NULL;
        INSERT INTO stats VALUES
          (col_name.column_name, col_name.data_type, mini, maximum, moyenne, mediane, ecart_type, nb_val, nb_valnull,
                                 nb_valzero, quant95, dis);

    ELSE
      NULL;
    END IF;
  END LOOP;
  COMMIT;
END;