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
  id          number,
  name        varchar2,
  description varchar2,
  constraint cert$pk primary key (id),
  constraint cert$name$nn check (name is not null),
  constraint cert$name$un unique (name)
);

create table status (
  id          number,
  name        varchar2,
  constraint status$pk primary key (id),
  constraint status$name$nn check (name is not null),
  constraint status$name$un unique (name)
);

create table genre (
  id   number,
  name varchar2,
  constraint genre$pk primary key (id),
  constraint genre$name$nn check (name is not null),
  constraint genre$name$un unique (name)
);

create table movie (
  id            number,
  title         varchar2,
  status        number,
  tagline       varchar2,
  release_date  date,
  vote_average  number,
  vote_count    number,
  certification number,
  runtime       number,
  budget        number,
  poster        blob,
  constraint movie$pk primary key (id),
  constraint movie$title$nn check (title is not null)
);

create table movie_director (
  movie    number,
  director number,
  constraint m_d$pk primary key (movie, director)
);

create table movie_genre (
  genre number,
  movie number,
  constraint m_g$pk primary key (genre, movie)
  ) ;

create table movie_actor
  (
  movie  number,
  actor number,
  constraint m_a$pk primary key (movie, actor)
);
