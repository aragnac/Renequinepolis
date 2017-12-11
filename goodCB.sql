DROP TABLE artist CASCADE CONSTRAINTS;
-- DROP TABLE certification CASCADE CONSTRAINTS;
-- DROP TABLE status CASCADE CONSTRAINTS;
DROP TABLE genre CASCADE CONSTRAINTS;
DROP TABLE movie CASCADE CONSTRAINTS;
DROP TABLE movie_director CASCADE CONSTRAINTS;
DROP TABLE movie_genre CASCADE CONSTRAINTS;
DROP TABLE movie_actor CASCADE CONSTRAINTS;
DROP TABLE utilisateur CASCADE CONSTRAINTS;
DROP TABLE commentaire CASCADE CONSTRAINTS;
DROP TABLE logerror CASCADE CONSTRAINTS;
DROP TABLE loginfos CASCADE CONSTRAINTS;

-- On y stoque les actors et les directors
CREATE TABLE artist (
  id   number(7),
  name varchar2(37),
  CONSTRAINT artist$pk PRIMARY KEY (id),
  CONSTRAINT artist$name$nn CHECK (name IS NOT NULL)
);

-- CREATE TABLE certification (
--   id          number(6),
--   name        varchar2(5),
--   description varchar2(50),
--   CONSTRAINT cert$pk PRIMARY KEY (id),
--   CONSTRAINT cert$name$nn CHECK (name IS NOT NULL),
--   CONSTRAINT cert$name$un UNIQUE (name)
--   --CONSTRAINT CHECK
-- );

-- CREATE TABLE status (
--   id   number(6),
--   name varchar2(15),
--   CONSTRAINT status$pk PRIMARY KEY (id),
--   CONSTRAINT status$name$nn CHECK (name IS NOT NULL),
--   CONSTRAINT status$name$un UNIQUE (name)
-- );

CREATE TABLE genre (
  id   number(5),
  name varchar2(16),
  CONSTRAINT genre$pk PRIMARY KEY (id),
  CONSTRAINT genre$name$nn CHECK (name IS NOT NULL),
  CONSTRAINT genre$name$un UNIQUE (name)
);

CREATE TABLE movie (
  id             number(6),
  title          varchar2(43),
  original_title varchar2(43),
  status         varchar2(16),
  release_date   date,
  vote_average   number(2),
  vote_count     number(4),
  certification  varchar2(6),
  runtime        number(5),
  poster         blob,
  CONSTRAINT movie$pk PRIMARY KEY (id),
  CONSTRAINT movie$title$nn CHECK (title IS NOT NULL),
  CONSTRAINT movie$rdate$nn CHECK (release_date IS NOT NULL),
  CONSTRAINT movie$runtime$nn CHECK (runtime IS NOT NULL),
  CONSTRAINT movie$certification CHECK (certification IN ('G', 'PG', 'PG-13', 'R', 'NC-17')),
  CONSTRAINT movie$status CHECK (status IN
                                 ('Post Production', 'Rumored', 'Released', 'In Production', 'Planned', 'Canceled'))
);

CREATE TABLE movie_director (
  director number(7) constraint m_d$fk$director REFERENCES artist(id),
  movie    number(6) CONSTRAINT m_d$fk$movie REFERENCES movie (id),
  CONSTRAINT m_d$pk PRIMARY KEY (movie, director)
);

CREATE TABLE movie_genre (
  genre number(5) constraint m_g$fk$genre REFERENCES genre(id),
  movie number(6) CONSTRAINT m_g$fk$movie REFERENCES movie (id),
  CONSTRAINT m_g$pk PRIMARY KEY (genre, movie)
);

CREATE TABLE movie_actor (
  actor number(6) constraint m_a$fk$actor REFERENCES artist(id),
  movie number(6) CONSTRAINT m_a$fk$movie REFERENCES movie (id),
  CONSTRAINT m_a$pk PRIMARY KEY (movie, actor)
);

CREATE TABLE utilisateur (
  id     integer GENERATED ALWAYS AS IDENTITY CONSTRAINT user$pk PRIMARY KEY,
  nom    varchar2(100),
  prenom varchar2(100)
);

CREATE TABLE commentaire (
  idutilisateur   integer CONSTRAINT commentaire$user$fk REFERENCES utilisateur (id),
  idfilm          number(6) CONSTRAINT commentaire$movie$fk REFERENCES movie (id),
  note            number(1),
  commentaire     varchar2(10000),
  datecommentaire date,
  CONSTRAINT commentaire$pk PRIMARY KEY (idutilisateur, idfilm),
  CONSTRAINT commentaire$user$nn CHECK (idutilisateur IS NOT NULL),
  CONSTRAINT commentaire$film$nn CHECK (idfilm IS NOT NULL)
);

CREATE TABLE logerror (
  instant TIMESTAMP DEFAULT current_timestamp(5) CONSTRAINT logerror$pk PRIMARY KEY,
  datem   DATE,
  titre   VARCHAR2(100),
  message VARCHAR2(10000)
);

CREATE TABLE loginfos (
  instant TIMESTAMP DEFAULT current_timestamp(5) CONSTRAINT loginfos$pk PRIMARY KEY,
  datem   DATE,
  titre   VARCHAR2(100),
  message VARCHAR2(10000)
);
