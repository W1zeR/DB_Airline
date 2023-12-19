-- Пропиши эти команды в Query Tool в своей бд
CREATE ROLE employee_manager_role WITH
	NOLOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1;
	
GRANT SELECT, INSERT, DELETE, UPDATE, TRUNCATE, REFERENCES, TRIGGER ON employee TO employee_manager_role;	
	
CREATE USER employee_manager PASSWORD '123' IN ROLE employee_manager_role;

CREATE ROLE admin WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  CREATEDB
  CREATEROLE
  NOREPLICATION
  PASSWORD '123';

-- Откртыть SQL Shell(psql). Подключаешься к бд db_airline под пользователем employee_manager с паролем 123 и вводишь эти команды

SELECT * FROM employee;

SELECT * FROM plane;
