DROP TABLE artist CASCADE CONSTRAINTS;
DROP TABLE certification CASCADE CONSTRAINTS;
DROP TABLE status CASCADE CONSTRAINTS;
DROP TABLE genre CASCADE CONSTRAINTS;
DROP TABLE movie CASCADE CONSTRAINTS;
DROP TABLE movie_director CASCADE CONSTRAINTS;
DROP TABLE movie_genre CASCADE CONSTRAINTS;
DROP TABLE movie_actor CASCADE CONSTRAINTS;
DROP TABLE utilisateur CASCADE CONSTRAINTS;
DROP TABLE commentaire CASCADE CONSTRAINTS;
DROP TABLE logerror CASCADE CONSTRAINTS;
DROP TABLE loginfos CASCADE CONSTRAINTS;

CREATE TABLE artist (
  id   NUMBER(7),
  name VARCHAR2(25),
  CONSTRAINT artist$pk PRIMARY KEY (id),
  CONSTRAINT artist$name$nn CHECK (name IS NOT NULL)
);

CREATE TABLE certification (
  id          NUMBER(6),
  name        VARCHAR2(25),
  description VARCHAR2(50),
  CONSTRAINT cert$pk PRIMARY KEY (id),
  CONSTRAINT cert$name$nn CHECK (name IS NOT NULL),
  CONSTRAINT cert$name$un UNIQUE (name)
);

CREATE TABLE status (
  id   NUMBER(6),
  name VARCHAR2(15),
  CONSTRAINT status$pk PRIMARY KEY (id),
  CONSTRAINT status$name$nn CHECK (name IS NOT NULL),
  CONSTRAINT status$name$un UNIQUE (name)
);

CREATE TABLE genre (
  id   NUMBER(6),
  name VARCHAR2(16),
  CONSTRAINT genre$pk PRIMARY KEY (id),
  CONSTRAINT genre$name$nn CHECK (name IS NOT NULL),
  CONSTRAINT genre$name$un UNIQUE (name)
);

CREATE TABLE movie (
  id             NUMBER(6),
  title          VARCHAR2(43),
  original_title VARCHAR2(393),
  status         NUMBER(2),
  release_date   DATE,
  vote_average   NUMBER(2),
  vote_count     NUMBER(4),
  certification  VARCHAR2(12),
  runtime        NUMBER(5),
  poster         BLOB,
  CONSTRAINT movie$pk PRIMARY KEY (id),
  CONSTRAINT movie$title$nn CHECK (title IS NOT NULL),
  CONSTRAINT movie$rdate$nn CHECK (release_date IS NOT NULL),
  CONSTRAINT movie$certification CHECK (certification IN ('G', 'PG', 'PG-13', 'R', 'NC-17'))
);

CREATE TABLE movie_director (
  director NUMBER(19),
  movie    NUMBER(6) CONSTRAINT m_d$fk$movie REFERENCES movie(id),
  CONSTRAINT m_d$pk PRIMARY KEY (movie, director)
);

CREATE TABLE movie_genre (
  genre NUMBER(2),
  movie NUMBER(6) CONSTRAINT m_g$fk$movie REFERENCES movie(id),
  CONSTRAINT m_g$pk PRIMARY KEY (genre, movie)
);

CREATE TABLE movie_actor (
  actor NUMBER(6),
  movie NUMBER(6) CONSTRAINT m_a$fk$movie REFERENCES movie(id),
  CONSTRAINT m_a$pk PRIMARY KEY (movie, actor)
);

CREATE TABLE utilisateur (
  id     INTEGER GENERATED ALWAYS AS IDENTITY CONSTRAINT user$pk PRIMARY KEY,
  nom    VARCHAR2(100),
  prenom VARCHAR2(100)
);

CREATE TABLE commentaire (
  idutilisateur INTEGER CONSTRAINT commentaire$user$fk REFERENCES utilisateur (id),
  idfilm        NUMBER(6) CONSTRAINT commentaire$movie$fk REFERENCES movie (id),
  commentaire   VARCHAR2(1000),
  CONSTRAINT commentaire$pk PRIMARY KEY (idutilisateur, idfilm)
);

CREATE TABLE logerror (
  instant TIMESTAMP CONSTRAINT logerror$pk PRIMARY KEY,
  datem   DATE,
  titre   VARCHAR2(100),
  message VARCHAR2(10000)
);

CREATE TABLE loginfos (
  instant TIMESTAMP CONSTRAINT loginfos$pk PRIMARY KEY,
  datem   DATE,
  titre   VARCHAR2(100),
  message VARCHAR2(10000)
);