DROP TABLE artist CASCADE CONSTRAINTS;
DROP TABLE certification CASCADE CONSTRAINTS;
DROP TABLE genre CASCADE CONSTRAINTS;
DROP TABLE movie CASCADE CONSTRAINTS;
DROP TABLE movie_director CASCADE CONSTRAINTS;
DROP TABLE movie_actor CASCADE CONSTRAINTS;
DROP TABLE movie_genre CASCADE CONSTRAINTS;
DROP TABLE status CASCADE CONSTRAINTS;

CREATE TABLE artist (
  id   NUMBER,
  name VARCHAR2(3650 CHAR),
  CONSTRAINT artist$pk PRIMARY KEY (id),
  CONSTRAINT artist$name$nn CHECK (name IS NOT NULL)
);

CREATE TABLE certification (
  id          NUMBER,
  name        VARCHAR2(20 CHAR),
  description VARCHAR2(200 CHAR),
  CONSTRAINT cert$pk PRIMARY KEY (id),
  CONSTRAINT cert$name$nn CHECK (name IS NOT NULL),
  CONSTRAINT cert$name$un UNIQUE (name)
);

CREATE TABLE status (
  id          NUMBER,
  name        VARCHAR2(20 CHAR),
  description VARCHAR2(200 CHAR),
  CONSTRAINT status$pk PRIMARY KEY (id),
  CONSTRAINT status$name$nn CHECK (name IS NOT NULL),
  CONSTRAINT status$name$un UNIQUE (name)
);

CREATE TABLE genre (
  id   NUMBER,
  name VARCHAR2(160 CHAR),
  CONSTRAINT genre$pk PRIMARY KEY (id),
  CONSTRAINT genre$name$nn CHECK (name IS NOT NULL),
  CONSTRAINT genre$name$un UNIQUE (name)
);

CREATE TABLE movie (
  id            NUMBER,
  title         VARCHAR2(400 CHAR),
  status        NUMBER CONSTRAINT movie$status$fk REFERENCES status (id),
  overview      VARCHAR2(500 CHAR),
  release_date  DATE,
  vote_average  NUMBER,
  vote_count    NUMBER,
  certification NUMBER CONSTRAINT movie$certification$fk REFERENCES certification (id),
  runtime       NUMBER,
  budget        NUMBER,
  poster        BLOB,
  CONSTRAINT movie$pk PRIMARY KEY (id),
  CONSTRAINT movie$title$nn CHECK (title IS NOT NULL)
);

CREATE TABLE movie_director (
  movie    NUMBER CONSTRAINT movie_director$movie$fk REFERENCES movie (id),
  director NUMBER CONSTRAINT movie_director$director$fk REFERENCES artist (id),
  CONSTRAINT m_d$pk PRIMARY KEY (movie, director)
);

CREATE TABLE movie_genre (
  genre NUMBER CONSTRAINT movie_genre$genre$fk REFERENCES genre (id),
  movie NUMBER CONSTRAINT movie_genre$movie$fk REFERENCES movie (id),
  CONSTRAINT m_g$pk PRIMARY KEY (genre, movie)
);

CREATE TABLE movie_actor
(
  movie NUMBER CONSTRAINT movie_actor$movie$fk REFERENCES movie (id),
  actor NUMBER CONSTRAINT movie_actor$artist$fk REFERENCES artist (id),
  CONSTRAINT m_a$pk PRIMARY KEY (movie, actor)
);

