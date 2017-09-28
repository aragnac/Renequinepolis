CREATE FUNCTION calcul_moyenne(moyenne OUT INTEGER)
RETURNS INTEGER
AS 
BEGIN
    DECLARE @avgLength as INTEGER

   	SELECT AVG(LENGTH ('title') AS moyenneclasse INTO @avgLength FROM movie ;

    RETURN @avgLength
END

CREATE FUNCTION distinct_satus()
RETURNS VARCHAR2
AS 
BEGIN
    DECLARE @distinctStatus VARCHAR2(50) = '''';

	SELECT @distinctStatus += x.status
	FROM( 	SELECT DISTINCT status + '-'  AS status
  			FROM movie
  			WHERE status <> ''
		) AS x 

	-- Add final apostrophe
	SET @distinctStatus = @var + ''''

	RETURN @distinctStatus
	 /*SELECT @concat = COALESCE(@concat, ' ') +  status
	 FROM
	 (

	    SELECT DISTINCT  status + ', ' AS statusMovie
	    FROM    movie
	    AND NOT status IS NULL
	  ) T*/
END