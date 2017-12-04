CREATE OR REPLACE TRIGGER trigger_movies
BEFORE INSERT ON movie
FOR EACH ROW
  BEGIN
    if (:new.certification not in ('G', 'PG', 'PG-13', 'R', 'NC-17')) THEN
      :new.certification := null;
    END IF;
    if (length(:new.title) > 43) then
      :new.title := substr(:new.title,0,43);
    end if;
    if (length(:new.original_title) > 43) THEN
      :new.original_title := substr(:new.title,0,43);
    END IF;
    if (:new.status not in ('Post Production', 'Rumored', 'Released', 'In Production', 'Planned', 'Canceled')) THEN
      :new.status := null;
    END IF;
  END;
/