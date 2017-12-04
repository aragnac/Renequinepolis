/**
 * AlimCB
 * Bonemme Nicolas & Simar Floryan
 * Groupe 2326
 */

-- Package specification
create or replace package pkgAlim as

    /* Types */
    type list_ids_temp is table of integer; -- list of ids
    type list_movies_temp is table of movies_ext%rowtype;

    /* Methods */
    procedure alimRandom(n integer);
    procedure alimCB_with_ids(ids list_ids_t);
    procedure addMovies(mov in out movies_ext%rowtype);
    procedure addLogError (Message IN log_erreur.message%type);
	  procedure addLodInfos (Message IN log_info.message%type);

end pkgAlim;
