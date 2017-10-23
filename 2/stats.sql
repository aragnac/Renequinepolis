DROP TABLE stats;
CREATE TABLE stats (
  champ         VARCHAR2(15) CONSTRAINT pk_stats PRIMARY KEY,
  datatype      VARCHAR2(8),
  mini          NUMBER,
  maxi          NUMBER,
  moyenne       NUMBER,
  medianne      NUMBER,
  ecartType     NUMBER,
  nbVal         NUMBER,
  nbNull        NUMBER,
  nbNotNull     NUMBER,
  nbZero        NUMBER,
  quant95       NUMBER,
  valdistinctes NUMBER
);
@StatsDirecteur
@StatsActeur
@StatsGenre
@MoviesStats
SELECT *
FROM stats
ORDER BY champ;