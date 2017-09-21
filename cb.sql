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
  vote_average  number(2),
  vote_count    number(6),
  certification number(4),
  runtime       number(3),
  budget        number(9),
  poster        blob,
  constraint movie$pk primary key (id),
  constraint movie$title$nn check (title is not null),
  constraint movie$rdate$nn check (release_date is not null
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
