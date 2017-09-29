DROP TABLE stats;
CREATE TABLE stats (
  champ         VARCHAR2(15) PRIMARY KEY,
  datatype      VARCHAR2(8),
  mini          INT,
  maxi          INT,
  moyenne       INT,
  medianne      INT,
  ecartType     INT,
  nbVal         INT,
  nbNull        INT,
  nbZero        INT,
  quant95       INT,
  valdistinctes INT
);
SELECT *
FROM stats
ORDER BY champ;