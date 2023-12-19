INSERT INTO country(id_country, name_of_country) VALUES (1, 'Россия');
INSERT INTO country(id_country, name_of_country) VALUES (2, 'Франция');
INSERT INTO country(id_country, name_of_country) VALUES (3, 'Великобритания');
INSERT INTO country(id_country, name_of_country) VALUES (4, 'Япония');

INSERT INTO city(id_city, id_country, name_of_city) VALUES 
	(1, (SELECT id_country FROM country WHERE name_of_country LIKE 'Россия'), 'Москва');
INSERT INTO city(id_city, id_country, name_of_city) VALUES 
	(2, (SELECT id_country FROM country WHERE name_of_country LIKE 'Франция'), 'Париж');
INSERT INTO city(id_city, id_country, name_of_city) VALUES 
	(3, (SELECT id_country FROM country WHERE name_of_country LIKE 'Россия'), 'Воронеж');

INSERT INTO airport(id_airport, id_city, code, name_of_airport) VALUES
	(1, (SELECT id_city FROM city WHERE name_of_city LIKE 'Москва'), 1, 'абв');
INSERT INTO airport(id_airport, id_city, code, name_of_airport) VALUES
	(2, (SELECT id_city FROM city WHERE name_of_city LIKE 'Париж'), 123, 'аауы');
INSERT INTO airport(id_airport, id_city, code, name_of_airport) VALUES
	(3, (SELECT id_city FROM city WHERE name_of_city LIKE 'Москва'), 2, 'пвп');

INSERT INTO equipage(id_equipage, flight_zone) VALUES (1, 'abcd');
INSERT INTO equipage(id_equipage, flight_zone) VALUES (2, 'vbd');
INSERT INTO equipage(id_equipage, flight_zone) VALUES (3, 'dfhh');

INSERT INTO post(id_post, name_of_post) VALUES (1, 'командир');
INSERT INTO post(id_post, name_of_post) VALUES (2, 'второй пилот');
INSERT INTO post(id_post, name_of_post) VALUES (3, 'бортинженер');
INSERT INTO post(id_post, name_of_post) VALUES (4, 'стюардесса');
INSERT INTO post(id_post, name_of_post) VALUES (5, 'test1');
INSERT INTO post(id_post, name_of_post) VALUES (6, 'test2');

INSERT INTO street(id_street, id_city, name_of_street)
	VALUES (1, (SELECT id_city FROM city WHERE name_of_city LIKE 'Москва'), 'абв');
INSERT INTO street(id_street, id_city, name_of_street)
	VALUES (2, (SELECT id_city FROM city WHERE name_of_city LIKE 'Париж'), 'авр');
INSERT INTO street(id_street, id_city, name_of_street)
	VALUES (3, (SELECT id_city FROM city WHERE name_of_city LIKE 'Воронеж'), 'пр');
INSERT INTO street(id_street, id_city, name_of_street)
	VALUES (4, (SELECT id_city FROM city WHERE name_of_city LIKE 'Воронеж'), 'sio');
INSERT INTO street(id_street, id_city, name_of_street)
	VALUES (5, (SELECT id_city FROM city WHERE name_of_city LIKE 'Москва'), 'z');

INSERT INTO employee(id_employee, id_equipage, id_post, id_street, passport_series_and_number,
	surname_employee, name_employee, patronymic_employee, employee_birthday, phone_employee,
	date_of_entry_into_position, date_of_leaving_position, home_employer, flat_employer)
	VALUES (1, (SELECT id_equipage FROM equipage WHERE flight_zone LIKE 'abcd'),
	(SELECT id_post FROM post WHERE name_of_post LIKE 'командир'),
	(SELECT id_street FROM street WHERE name_of_street LIKE 'абв'), '1345', 'zxc', 'dg', 'a', 
	'2001-01-01', '12455', '2005-02-02', NULL, 'ыа', 12);
INSERT INTO employee(id_employee, id_equipage, id_post, id_street, passport_series_and_number,
	surname_employee, name_employee, patronymic_employee, employee_birthday, phone_employee,
	date_of_entry_into_position, date_of_leaving_position, home_employer, flat_employer)
	VALUES (2, (SELECT id_equipage FROM equipage WHERE flight_zone LIKE 'abcd'),
	(SELECT id_post FROM post WHERE name_of_post LIKE 'второй пилот'),
	(SELECT id_street FROM street WHERE name_of_street LIKE 'авр'), '2426', 'авр', 'пврва', NULL, 
	'1994-01-01', '11467', '2002-01-01', NULL, 'аыв', 124);
INSERT INTO employee(id_employee, id_equipage, id_post, id_street, passport_series_and_number,
	surname_employee, name_employee, patronymic_employee, employee_birthday, phone_employee,
	date_of_entry_into_position, date_of_leaving_position, home_employer, flat_employer)
	VALUES (3, (SELECT id_equipage FROM equipage WHERE flight_zone LIKE 'abcd'),
	(SELECT id_post FROM post WHERE name_of_post LIKE 'второй пилот'),
	(SELECT id_street FROM street WHERE name_of_street LIKE 'авр'), '2424', 'аврzg', 'п', NULL, 
	'1990-01-01', '11467', '2002-01-01', NULL, 'аыв', 124);
INSERT INTO employee(id_employee, id_equipage, id_post, id_street, passport_series_and_number,
	surname_employee, name_employee, patronymic_employee, employee_birthday, phone_employee,
	date_of_entry_into_position, date_of_leaving_position, home_employer, flat_employer)
	VALUES (4, (SELECT id_equipage FROM equipage WHERE flight_zone LIKE 'abcd'),
	(SELECT id_post FROM post WHERE name_of_post LIKE 'второй пилот'), 
	(SELECT id_street FROM street WHERE name_of_street LIKE 'авр'), '2425', 'аврqa', 'пв', NULL, 
	'2023-01-01', '11467', '2002-01-01', NULL, 'аыв', 124);

INSERT INTO type_airplane(id_type, mark, flight_lenght, count_of_businesses_places,
	count_of_budget_places, count_of_first_places, max_flight_hieght, speed, max_weight)
	VALUES (1, 'первый', 12345, 14, 15, 3, 25, 130, 30);
INSERT INTO type_airplane(id_type, mark, flight_lenght, count_of_businesses_places,
	count_of_budget_places, count_of_first_places, max_flight_hieght, speed, max_weight)
	VALUES (2, 'sds', 123000, 150, 150, 100, 21, 120, 132);

INSERT INTO plane(board_number, id_type, period_of_operation, year_of_release)
	VALUES (1, (SELECT id_type FROM type_airplane WHERE mark LIKE 'первый'), 
	'2021-03-03', '2021-01-01');
INSERT INTO plane(board_number, id_type, period_of_operation, year_of_release)
	VALUES (2, (SELECT id_type FROM type_airplane WHERE mark LIKE 'sds'),
	'2000-01-01', '2000-05-05');

INSERT INTO flight(id_flight, id_equipage, id_airport_start, id_airport_finish,
	board_number, date_and_time_start, date_and_time_finish)
	VALUES (1, (SELECT id_equipage FROM equipage WHERE flight_zone LIKE 'abcd'),
	(SELECT id_airport FROM airport WHERE name_of_airport LIKE 'абв'),
	(SELECT id_airport FROM airport WHERE name_of_airport LIKE 'аауы'),
	1, '2023-10-09 00:00:00', '2023-10-10 00:00:00');
INSERT INTO flight(id_flight, id_equipage, id_airport_start, id_airport_finish,
	board_number, date_and_time_start, date_and_time_finish)
	VALUES (2, (SELECT id_equipage FROM equipage WHERE flight_zone LIKE 'vbd'),
	(SELECT id_airport FROM airport WHERE name_of_airport LIKE 'абв'),
	(SELECT id_airport FROM airport WHERE name_of_airport LIKE 'пвп'),
	2, '2023-01-01 00:00:00', '2023-02-01 00:00:00');
	

INSERT INTO passenger(id_passenger, id_street, passport_series_and_number, birthday_passenger,
	surname_passenger, name_passenger, patronimic_passenger, home_passenger, flat_passenger)
	VALUES (2, (SELECT id_street FROM street WHERE name_of_street LIKE 'абв'),
	'123', '1999-01-01', 'a', 'a', 'a', 'dg', 1);
INSERT INTO passenger(id_passenger, id_street, passport_series_and_number, birthday_passenger,
	surname_passenger, name_passenger, patronimic_passenger, home_passenger, flat_passenger)
	VALUES (1, (SELECT id_street FROM street WHERE name_of_street LIKE 'авр'),
	'356', '2005-09-07', 'b', 'b', 'b', 'sg', 2);
INSERT INTO passenger(id_passenger, id_street, passport_series_and_number, birthday_passenger,
	surname_passenger, name_passenger, patronimic_passenger, home_passenger, flat_passenger)
	VALUES (3, (SELECT id_street FROM street WHERE name_of_street LIKE 'абв'),
	'453', '1999-01-01', 'пв', 'пврва', 'a', 'dg', 1);
INSERT INTO passenger(id_passenger, id_street, passport_series_and_number, birthday_passenger,
	surname_passenger, name_passenger, patronimic_passenger, home_passenger, flat_passenger)
	VALUES (4, (SELECT id_street FROM street WHERE name_of_street LIKE 'абв'), 
	'457', '1999-01-01', 'пвр', 'пврва', 'a', 'dg', 1);

INSERT INTO ticket(id_ticket, id_flight, id_passenger, cost, "row", site, class,
	type_of_baggage, weight_of_baggage)
	VALUES (1, 1, 1, 123, 1, 1, 'первый', 'сумки', 123);
INSERT INTO ticket(id_ticket, id_flight, id_passenger, cost, "row", site, class,
	type_of_baggage, weight_of_baggage)
	VALUES (2, 2, 2, 13, 4, 4, 'аб', 'фв', 12);
