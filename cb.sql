-- Attention, le code SQL n'est pas syntaxiquement correct. Les VARCHAR2 n'ont pas de taille.
-- De plus toutes les valeurs numériques ont le type NUMBER ce qui est trop permissif.
-- Le script SQL doit donc être adapté par rapport à ceux deux points en plus de ce qui est demandé dans l'énoncé de laboratoire.

CREATE TABLE artist (
  id   number(6),
  name varchar2(25),
  CONSTRAINT artist$pk PRIMARY KEY (id),
  CONSTRAINT artist$name$nn CHECK (name IS NOT NULL)
);

CREATE TABLE certification (
  id          number(6),
  name        varchar2(25),
  description varchar2(50),
  CONSTRAINT cert$pk PRIMARY KEY (id),
  CONSTRAINT cert$name$nn CHECK (name IS NOT NULL),
  CONSTRAINT cert$name$un UNIQUE (name)
);

CREATE TABLE status (
  id   number(6),
  name varchar2(25),
  CONSTRAINT status$pk PRIMARY KEY (id),
  CONSTRAINT status$name$nn CHECK (name IS NOT NULL),
  CONSTRAINT status$name$un UNIQUE (name)
);

CREATE TABLE genre (
  id   number(6),
  name varchar2(25),
  CONSTRAINT genre$pk PRIMARY KEY (id),
  CONSTRAINT genre$name$nn CHECK (name IS NOT NULL),
  CONSTRAINT genre$name$un UNIQUE (name)
);

CREATE TABLE movie (
  id            number(6),
  title         varchar2(30),
  status        number(1),
  tagline       varchar2(150),
  release_date  date,
  vote_average  number(2),
  vote_count    number(6),
  certification number(4),
  runtime       number(3),
  budget        number(9),
  poster        blob,
  CONSTRAINT movie$pk PRIMARY KEY (id),
  CONSTRAINT movie$title$nn CHECK (title IS NOT NULL),
  CONSTRAINT movie$rdate$nn CHECK (release_date IS NOT NULL)
  --constraint movie$certification check (certification in ('G', 'PG', 'PG-13', 'R', 'NC-17'))
);

CREATE TABLE movie_director (
  movie    number,
  director number,
  CONSTRAINT m_d$pk PRIMARY KEY (movie, director)
);

CREATE TABLE movie_genre (
  genre number(2),
  movie number(9),
  CONSTRAINT m_g$pk PRIMARY KEY (genre, movie)
);

CREATE TABLE movie_actor (
  movie number(9),
  actor number(6),
  CONSTRAINT m_a$pk PRIMARY KEY (movie, actor)
);
CREATE TABLE logerror (
  instant date,
  titre   varchar2(100),
  message varchar2(10000)
);
CREATE TABLE loginfos (
  instant date,
  titre   varchar2(100),
  message varchar2(10000)
);
