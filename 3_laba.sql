/* Хранимая функция, которая вычисляет количество авиабилетов,
купленных за всё время пассажиром с определённым id */

CREATE OR REPLACE FUNCTION count_tickets_by_passenger_id (passenger_id bigint)
RETURNS bigint
AS $$
BEGIN
	RETURN
		(SELECT COUNT(*)
		FROM ticket t
		WHERE t.id_passenger = passenger_id);
END;
$$ LANGUAGE plpgsql;

select count_tickets_by_passenger_id(1);

/* Триггер, отвечающий за проверку того, что дата полёта
не может быть раньше, чем дата выпуска самолёта */

CREATE OR REPLACE FUNCTION check_flight_date()
RETURNS trigger
AS $$
BEGIN
    IF (to_date(cast(NEW.date_and_time_start as TEXT),'YYYY-MM-DD') <
		(SELECT p.year_of_release
		FROM plane p
		WHERE NEW.board_number = p.board_number))
	THEN
        RAISE EXCEPTION 'Flight start date cannot be less than plane release';
    END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_flight_date_trigger
BEFORE INSERT OR UPDATE ON flight
FOR EACH ROW
EXECUTE FUNCTION check_flight_date();

SELECT p.year_of_release
FROM plane p
WHERE p.board_number = 1;

INSERT INTO flight (id_equipage, id_airport_start, id_airport_finish, board_number,
date_and_time_start, date_and_time_finish)
VALUES (1, 1, 2, 1, '1800-01-01', '1800-01-02');

INSERT INTO flight (id_equipage, id_airport_start, id_airport_finish, board_number,
date_and_time_start, date_and_time_finish)
VALUES (1, 1, 2, 1, '2023-01-01', '2023-01-02');


/* Триггер для аудита цен на авиабилеты */

CREATE TABLE ticket_history(LIKE ticket);

ALTER TABLE ticket_history 
RENAME COLUMN cost TO new_cost;

ALTER TABLE ticket_history 
ADD old_cost NUMERIC NOT NULL,
ADD change_date TIMESTAMP NOT NULL;

CREATE OR REPLACE FUNCTION ticket_history_update()
RETURNS trigger
AS $$
BEGIN
    EXECUTE format
		('INSERT INTO %I SELECT ($1).*, ($2), current_timestamp',
		TG_TABLE_NAME||'_history')
		USING NEW, OLD.cost;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER ticket_history_update_trigger
AFTER UPDATE ON ticket
FOR EACH ROW
WHEN (NEW.cost IS DISTINCT FROM OLD.cost)
EXECUTE FUNCTION ticket_history_update();

SELECT * FROM ticket_history;
UPDATE ticket SET cost = 100 WHERE id_ticket = 1;
SELECT * FROM ticket_history;