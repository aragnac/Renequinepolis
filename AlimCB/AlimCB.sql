create or replace package body pkgAlim as

    procedure alimRandom(n integer) is
            invalid_n exception;
            list_movies list_movies_temp;
        begin
            -- Checking n (number)
            if (n <= 0) then
                addLogInfos('wrong parameter : null or neg');
            end if;

            -- Collecting the movies
            with rand as (
                select * from movies_ext
                where id not in (select id from movie)
                order by dbms_random.value
            )
            select * bulk collect into list_movies from rand
            where rownum <= n;

            if (list_movies.count < n) then
                addLogInfos('add random movies : Not enough movies found');
            end if;

            -- Adding movies
            for i in list_movies.first .. list_movies.last loop
                addMovies(list_movies(i));
            end loop;
            exception
            when others then
            addLogError('Add random movies error : ' || SQLERRM || '-' || SQLCODE);
            raise;

        end alimRandom;
/***********************************************************************************************************/

    -- Alimentation CB avec liste ID précis
    procedure alimCB_with_ids(ids list_ids_temp) is
        list_movies list_movies_temp;
    begin
        -- Checking parameter
        if (ids is null or ids.count < 1) then
            addLogError('alim with IDs : Parameter "ids" is null or empty.');
        end if;
        
        -- Collecting the movies
        select * bulk collect into list_movies
        from movies_ext
        where id in (select * from table(ids));
        
        -- Checking the results
        if (list_movies.count < ids.count) then
            addLogError('alim with IDs: Movie id not found.');
        elsif (list_movies.count > ids.count) then
            addLogInfos('alim with IDs : too many movies found, maybe duplicate, AlimCB.');
        end if;
        
        -- Processing the movies
        for i in list_movies.first .. list_movies.last loop
            addMovies(list_movies(i));
        end loop;

    exception
        when others then
            addLogError('alim with IDs : ' || SQLERRM || '-' || SQLCODE);
            raise;
        
    end alimCB_with_ids;

/**************************************************************************/
    function trim_str(line_in in varchar2)
        return varchar2
    is
        begin
            return trim(regexp_replace(line_in, '[[:cntrl:]]|  +' , null));
        end trim_str;
/**************************************************************************/

    --Ajout du film dans la table Movie et ajout dans le log
    procedure addMovies(movie in out movies_ext%rowtype)
    is
        certification_id integer := null;
        image blob := null;
        exception_init exception;
        insert_error exception;
        pragma (insert_error, -20010);

        begin
        /* check fields for movie table */

        movie.title := trim_str(movie.title);
        if (lengthb(movie.title) > 43) then
            movie.title := substrb(movie.title, 1, 40) || '...'; -- Add ... when film title is too long
            addLogInfos('Title of movie: ' || movie.id || ' was too long. End replaced with ... .');
        end if;

        movie.original_title := trim_str(movie.original_title);
        if (lengthb(movie.original_title) > 43) then
            movie.original_title := substrb(movie.original_title, 1, 40) || '...';
            addLogInfos('Original title of movie: ' || movie.id || ' was too long. End replaced with ... .');
        end if;

        if (movie.status is not null) then
            movie.status := initcap(lower(movie.status));
        end if;

        if(movie.certification is not null ) then
            if (movie.certification = 'G' OR movies.certification = 'PG' OR movie.certification = 'PG-13' OR movies.certification = 'R' OR movies.certification = 'NC-17') then
                movie.certification := upper(movie.certification);
            else
                addLogInfos('Check certification : Wrong value.');
        end if;
        
        -- tagline
        movie.tagline := trim_str(movie.tagline);
        if (movie.tagline is not null and (lengthb(movie.tagline) > 107)) then
            movie.tagline := substrb(movie.tagline, 1, 104) || '...';
            addLogInfos('Tagline of movie: ' || movie.id || ' truncated.');
        end if;
        
        -- get the certification id
        begin
            select id into certification_id from certification where lower(name) = lower(movie.certification);
        exception when no_data_found then
            certification_id := null;
            addLogInfos('No certification found for movie: ' || mov.id || ', certification set to null.');
        end;
        
        -- get the blob from the poster_path
        begin
        if (movie.poster_path is not null) then
            image := httpuritype.createuri('http://image.tmdb.org/t/p/w185' || movie.poster_path).getblob();
        end if;
        exception when others then
            image := empty_blob();
            addLogInfos('Could not find blob for movie: ' || movie.id || ', blob set to empty_blob.');
        end;

        -- Inserting the movie
        savepoint before_insert;
        insert into movie values (
            cast(movie.id as integer),
            movie.title,
            movie.original_title,
            movie.status,
            movie.tagline,
            movie.release_date,
            round(movie.vote_average, 1),
            cast(movie.vote_count as integer),
            certification_id,
            cast(movie.runtime as integer),
            image,
            0,
            0
        );
        addLogInfos('The movie: ' || movie.id || ' was succesfully added.');

        -- Inserting the composite fields
        insert_composite(movie.actors, 1, movie.id);
        insert_composite(movie.directors, 2, movie.id);
        insert_composite(movie.genres, 3, movie.id);
        commit;

        exception
            when DUP_VAL_ON_INDEX then
                pkgLog.add_info_log('Movie: ' || movie.id || ' already exists.');
                rollback to before_insert;
            when others then
                raise_application_error(-20010, 'Exception when inserting the movie: ' || mov.id || '. Cause: ' || SQLERRM);
                rollback to before_insert;
    end add_movie;

/**************************************************************************************************************/

    /*procedure insert_composite(line_in in varchar2, type_in in integer, movieId_in in integer)
    is
        id integer;
        name varchar2(200); -- cf. csv
        i number := 1;
        doInsert boolean := true;
        duplicate_in_str exception;
        pragma exception_init(duplicate_in_str, -2291); -- doublons, ex: movie 447725 deux fois le même acteur sur la même ligne
    */
    procedure insertActor(line in VARCHAR2, movieId in integer) is
        id integer;
        name varchar2(200);
        i number := 1;
        doInsert boolean := true;
        begin
            loop
                -- extraction
                id := TO_NUMBER(REGEXP_SUBSTR(line,'(‖|^)(\d+)․',1,i,null,2));
                dbms_output.put_line('--->' || id); -- debug
                name := trim_str(REGEXP_SUBSTR(line,'․([^․‖]+)․',1,i,null,1));
                exit when id is null;

                if (lengthb(name) > 20) then
                    name := substrb(name, 1, 17) || '...';
                    addLogInfos('Name of actor: ' || id || ' truncated.');
                end if;

                -- actor
                doInsert := true;
                savepoint before_actor;
                begin
                    insert into artist (id, name) values(id, name);
                    addLogInfos('Actor: ' || id || ' inserted.');
                    exception
                    when DUP_VAL_ON_INDEX then
                    rollback to before_actor;
                    addLogInfos('Actor: ' || id || ' already exists.');
                    when others then
                    rollback to before_actor;
                    addLogInfos('Exception when inserting actor: ' || id || '.  Cause: ' || SQLERRM || ' - ' || SQLCODE);
                    doInsert := false;
                end;

                -- si OK ou acteur déjà présent pour quand meme faire le lien
                -- movie_actor
                savepoint before_link_actor;
                if (doInsert = true) then
                    begin
                        insert into movie_actor (movie, artist) values(movieId, id);
                        addLogInfos('Link movie_actor of movie: ' || movieId || ' and actor: ' || id || ' inserted.', $$PLSQL_UNIT);
                        exception
                        when DUP_VAL_ON_INDEX then
                        rollback to before_link_actor;
                        addLogInfos('Link movie_actor of movie: ' || movieId_in || ' and actor: ' || id || ' already exists.', $$PLSQL_UNIT);
                        when duplicate_in_str then
                        rollback to before_link_actor;
                        addLogInfos('Link movie_actor of movie: ' || movieId_in || ' and actor: ' || id || ' already inserted with another id.', $$PLSQL_UNIT);
                        when others then
                        rollback to before_link_actor;
                        addLogInfos('Exception when inserting link movie_actor of movie: ' || movieId_in || ' and actor: ' || id || ': ' || SQLERRM, SQLCODE, $$PLSQL_UNIT);
                    end;
                end if;
                i := i + 1;
            end loop;
    end insertActor;

    procedure insertDirector(line in VARCHAR2, movieId in integer) is
        id integer;
        name varchar2(200);
        i number := 1;
        doInsert boolean := true;
        begin

        loop
            -- extraction
            id := TO_NUMBER(REGEXP_SUBSTR(line,'(‖|^)(\d+)․',1,i,null,2));
            dbms_output.put_line('--->' || id);
            name := trim_str(REGEXP_SUBSTR(line,'[^․‖]+',1,i+1));
            exit when id is null;

            if (lengthb(name) > 20) then
                name := substrb(name, 1, 17) || '...';
                addLogInfos('Name of director: ' || id || ' truncated.');
            end if;

            -- director
            doInsert := true;
            savepoint before_director;
            begin
                insert into artist (id, name) values(id, name);
                addLogInfos('Director: ' || id || ' inserted.');
                exception
                when DUP_VAL_ON_INDEX then
                rollback to before_director;
                addLogInfos('Director: ' || id || ' already exists.');
                when others then
                rollback to before_director;
                addLogInfos('Exception when inserting director: ' || id || '.  Cause: ' || SQLERRM || ' - ' ||SQLCODE);
                doInsert := false;
            end;

            -- movie_director
            savepoint before_link_director;
            if (doInsert = true) then
                begin
                    insert into movie_director (movie, artist) values(movieId, id);
                    addLogInfos('Link movie_director of movie: ' || movieId || ' and director: ' || id || ' inserted.');
                    exception
                    when DUP_VAL_ON_INDEX then
                    rollback to before_link_director;
                    addLogInfos('Link movie_director of movie: ' || movieId || ' and director: ' || id || ' already exists.');
                    when duplicate_in_str then
                    rollback to before_link_director;
                    addLogInfos('Link movie_director of movie: ' || movieId || ' and director: ' || id || ' already inserted with another id.');
                    when others then
                    rollback to before_link_director;
                    addLogError('Exception when inserting link movie_director of movie: ' || movieId || ' and director: ' || id || ': ' || SQLERRM || ' - ' ||SQLCODE);
                end;
            end if;

            i := i + 2;
        end loop;
    end insertDirector;

    procedure insertGenre(line in VARCHAR2, movieId in integer) is
        id integer;
        name varchar2(200);
        i number := 1;
        doInsert boolean := true;

        begin
        loop
            --extraction
            id := TO_NUMBER(REGEXP_SUBSTR(line,'[^․‖]+',1,i));
            dbms_output.put_line('--->' || id);
            name := trim_str(REGEXP_SUBSTR(line,'[^․‖]+',1,i+1));
            exit when id is null;

            -- genre
            doInsert := true;
            savepoint before_genre;
            begin
                insert into genre (id, name) values(id, name);
                addLogInfos('Genre: ' || id || ' inserted.');
                exception
                when DUP_VAL_ON_INDEX then
                rollback to before_genre;
                addLogInfos('Genre: ' || id || ' already exists.');
                when others then
                rollback to before_genre;
                addLogError('Exception when inserting genre: ' || id || '.  Cause: ' || SQLERRM || ' - ' ||SQLCODE);
                doInsert := false;
            end;

            -- movie_genre
            savepoint before_link_genre;
            if (doInsert = true) then
                begin
                    insert into movie_genre (movie, genre) values(movieId, id);
                    addLogInfos('Link movie_genre of movie: ' || movieId || ' and genre: ' || id || ' inserted.');
                    exception
                    when DUP_VAL_ON_INDEX then
                    rollback to before_link_genre;
                    addLogInfos('Link movie_genre of movie: ' || movieId || ' and genre: ' || id || ' already exists.');
                    when duplicate_in_str then
                    rollback to before_link_genre;
                    addLogInfos('Link movie_genre of movie: ' || movieId || ' and genre: ' || id || ' already inserted with another id.');
                    when others then
                    rollback to before_link_genre;
                    addLogError('Exception when inserting link movie_genre of movie: ' || movieId_in || ' and genre: ' || id || ': ' || SQLERRM || ' - ' ||SQLCODE);
                end;
            end if;

            i := i + 2;
        end loop;
    end insertGenre;




                                    /**************************************/
                                    /************* ADD LOGS ***************/
                                    /**************************************/
    procedure addLogError (m in logerror.message%type) as
        date_error varchar2(21 char);
        begin
            select to_char(localtimestamp, 'YYYY-MM-DD HH24:MI:SS') into date_error from DUAL;

            insert into logerror values( erreur_date, 'titre' , m);
            commit;
            exception
            when others then addLogError('AaddLogError : ' || SQLERRM);
        end;

    procedure addLogInfos (m in loginfos.message%type) as
        date_infos varchar2(21 char);
        begin
            select to_char(localtimestamp, 'YYYY-MM-DD HH24:MI:SS') into info_date from DUAL;

            insert into loginfos VALUES(darte_infos, 'titre', m);
            commit;
            exception
            when others then addLogError('addLogInfos : ' || SQLERRM);
        END;