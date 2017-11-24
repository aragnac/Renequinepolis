create or replace package body pkgAlim as
    
    -- Alimentation CB avec liste ID précis
    procedure alimCB_with_ids(ids list_ids_t)
    is
        invalid_ids     exception;
        id_not_found    exception;
        pragma exception_init(invalid_ids, -20001);
        pragma exception_init(id_not_found, -20002);
        list_movies list_movies_t;
    begin
        -- Checking parameter
        if (ids is null or ids.count < 1) then
            raise_application_error(-20001, 'Parameter "ids" is invalid (null or empty).');
        end if;
        
        -- Collecting the movies (~5secs)
        select * bulk collect into list_movies
        from movies_ext
        where id in (select * from table(ids));
        
        -- Checking the results
        if (list_movies.count < ids.count) then
            raise_application_error(-20002, 'Movie id could not be found.');
        elsif (list_movies.count > ids.count) then
            pkgLog.add_info_log('Warning: Duplicate found in AlimCB.', $$PLSQL_UNIT);
        end if;
        
        -- Processing the movies
        for i in list_movies.first .. list_movies.last loop
            print_movie(list_movies(i));
            add_movie(list_movies(i));
        end loop;

    exception
        when others then
            pkgLog.add_error_log(SQLERRM, SQLCODE, $$PLSQL_UNIT);
            raise;
        
    end alimCB_with_ids;

/**************************************************************************/
   
        --Ajout du film dans la table Movie et ajout dans le log
    procedure add_movie(mov in out movies_ext%rowtype)
    is
        certification_id integer := null;
        image blob := null;
        exception_init
        insert_error exception;
        pragma (insert_error, -20010);
        begin
        /* Verifying the movie */
        -- title
        mov.title := trim_str(mov.title);
        if (lengthb(mov.title) > 43) then
            mov.title := substrb(mov.title, 1, 40) || '...'; -- caractère 
            pkgLog.add_info_log('Title of movie: ' || mov.id || ' truncated.', $$PLSQL_UNIT);
        end if;
        
        -- original_title
        mov.original_title := trim_str(mov.original_title);
        if (lengthb(mov.original_title) > 43) then
            mov.original_title := substrb(mov.original_title, 1, 40) || '...';
            pkgLog.add_info_log('Original title of movie: ' || mov.id || ' truncated.', $$PLSQL_UNIT);
        end if;
        
        -- status
        if (mov.status is not null) then
            mov.status := initcap(lower(mov.status));
        end if;
        
        -- certification
        if (mov.certification is not null) then
            mov.certification := upper(mov.certification);
        end if;
        
        -- tagline
        mov.tagline := trim_str(mov.tagline);
        if (mov.tagline is not null and (lengthb(mov.tagline) > 107)) then
            mov.tagline := substrb(mov.tagline, 1, 104) || '...';
            pkgLog.add_info_log('Tagline of movie: ' || mov.id || ' truncated.', $$PLSQL_UNIT);
        end if;
        
        -- get the certification id
        begin
            select id into certification_id from certification where lower(name) = lower(mov.certification);
        exception when no_data_found then
            certification_id := null;
            pkgLog.add_info_log('No certification found for movie: ' || mov.id || ', certification set to null.', $$PLSQL_UNIT);
        end;
        
        -- get the blob from the poster_path
        begin
        if (mov.poster_path is not null) then
            image := httpuritype.createuri('http://image.tmdb.org/t/p/w185' || mov.poster_path).getblob();
        end if;
        exception when others then
            image := empty_blob();
            pkgLog.add_info_log('Could not find blob for movie: ' || mov.id || ', blob set to empty_blob.', $$PLSQL_UNIT);
        end;

        -- Inserting the movie
        savepoint before_insert;
        insert into movie values (
            cast(mov.id as integer),
            mov.title,
            mov.original_title,
            mov.status,
            mov.tagline,
            mov.release_date,
            round(mov.vote_average, 1),
            cast(mov.vote_count as integer),
            certification_id,
            cast(mov.runtime as integer),
            image,
            0,
            0
        );
        pkgLog.add_info_log('Movie: ' || mov.id || ' inserted.', $$PLSQL_UNIT); -- success

        -- Inserting the composite fields
        insert_composite(mov.actors, 1, mov.id);
        insert_composite(mov.directors, 2, mov.id);
        insert_composite(mov.genres, 3, mov.id);
        commit;

        exception
            when DUP_VAL_ON_INDEX then
                pkgLog.add_info_log('Movie: ' || mov.id || ' already exists.', $$PLSQL_UNIT);
                rollback to before_insert;
            when others then
                raise_application_error(-20010, 'Exception when inserting the movie: ' || mov.id || '. Cause: ' || SQLERRM);
                rollback to before_insert;
    end add_movie;