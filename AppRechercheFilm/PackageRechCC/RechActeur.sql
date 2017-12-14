SELECT *
FROM MOVIE_ACTOR
GROUP BY MOVIE, ACTOR
HAVING MOVIE_ACTOR.ACTOR = ALL (SELECT ID
                                FROM ARTIST
                                WHERE NAME IN ('Zbigniew Zamachowski', 'Julie Delpy'));