CREATE TABLE movies_ext (
  id             integer,
  title          varchar2(2000 char),
  original_title varchar2(2000 char),
  release_date   date,
  status         varchar2(30 char),
  vote_average   number(3, 1),
  vote_count     integer,
  runtime        integer,
  certification  varchar2(30 char),
  poster_path    varchar2(100 char),
  budget         integer,
  tagline        varchar2(10000 char),
  genres         varchar2(1000 char),
  directors      varchar2(10000 char),
  actors         varchar2(10000 char)
)
ORGANIZATION EXTERNAL (
TYPE ORACLE_LOADER
DEFAULT DIRECTORY mydir
ACCESS PARAMETERS (
  RECORDS DELIMITED BY "\n"
    CHARACTERSET "AL32UTF8"
    STRING SIZES ARE IN CHARACTERS
  FIELDS TERMINATED BY X "E280A3"
MISSING FIELD VALUES ARE NULL
(
ID UNSIGNED INTEGER EXTERNAL,
  title CHAR (2000
),
  original_title CHAR (2000
),
  release_date CHAR (10
) DATE_FORMAT DATE MASK "yyyy-mm-dd",
  status CHAR (30
),
  vote_average FLOAT EXTERNAL,
  vote_count UNSIGNED INTEGER EXTERNAL,
  runtime UNSIGNED INTEGER EXTERNAL,
  certification CHAR (30
),
  poster_path CHAR (100
),
  budget UNSIGNED INTEGER EXTERNAL,
  tagline CHAR (10000
),
  genres CHAR (1000
),
  directors CHAR (10000
),
  actors CHAR (10000
)
)
)
LOCATION ('movies.txt'
)
)
REJECT LIMIT UNLIMITED;