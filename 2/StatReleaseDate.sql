SELECT
  min(release_date)            AS minimum,
  max(release_date)            AS maximum,
  median(release_date)         AS medianne,
  count(release_date)          AS nb_Val,
  sum(CASE WHEN release_date IS NULL
    THEN 1
      ELSE 0 END)              AS nb_ValNull,
  percentile_cont(0.95)
  WITHIN GROUP (
    ORDER BY release_date)     AS quant95,
  count(DISTINCT release_date) AS distvalues
FROM movies_ext;
