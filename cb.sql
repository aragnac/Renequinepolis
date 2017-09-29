<<<<<<< HEAD
-- Attention, le code SQL n'est pas syntaxiquement correct. Les VARCHAR2 n'ont pas de taille.
-- De plus toutes les valeurs numériques ont le type NUMBER ce qui est trop permissif.
-- Le script SQL doit donc être adapté par rapport à ceux deux points en plus de ce qui est demandé dans l'énoncé de laboratoire.

create table artist (
  id   number(6),
  name varchar2(25),
  constraint artist$pk primary key (id),
  constraint artist$name$nn check (name is not null)
);

create table certification (
  id          number(6),
  name        varchar2(25),
  description varchar2(50),
  constraint cert$pk primary key (id),
  constraint cert$name$nn check (name is not null),
  constraint cert$name$un unique (name)
);

create table status (
  id          number(6),
  name        varchar2(25),
  constraint status$pk primary key (id),
  constraint status$name$nn check (name is not null),
  constraint status$name$un unique (name)
);

create table genre (
  id   number(6),
  name varchar2(25),
  constraint genre$pk primary key (id),
  constraint genre$name$nn check (name is not null),
  constraint genre$name$un unique (name)
);

create table movie (
  id            number(6),
  title         varchar2(30),
  status        number(1),
  tagline       varchar2(150),
  release_date  date,
  vote_average  int,
  vote_count    int,
  certification number(4),
  runtime       int,
  budget        int,
  poster        blob,
  constraint movie$pk primary key (id),
  constraint movie$title$nn check (title is not null),
  constraint movie$rdate$nn check (release_date is not null)
  --constraint movie$certification check (certification in ('G', 'PG', 'PG-13', 'R', 'NC-17'))
);

create table movie_director (
  movie    number,
  director number,
  constraint m_d$pk primary key (movie, director)
);

create table movie_genre (
  genre number(2),
  movie number(9),
  constraint m_g$pk primary key (genre, movie)
  ) ;

create table movie_actor
  (
  movie  number(9),
  actor number(6),
  constraint m_a$pk primary key (movie, actor)
);
=======
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
>>>>>>> 5c89e70c6700eb82b657e8cc496d18425abff465
