/*==============================================================*/
/* Table: type_airplane                                         */
/*==============================================================*/
CREATE TABLE type_airplane 
(
   id_type              serial                        NOT NULL,
   mark                 varchar(50)                    NOT NULL,
   flight_lenght      integer                        NOT NULL,
   count_of_businesses_places integer                        NULL,
   count_of_budget_places smallint                        NOT NULL,
   count_of_first_places smallint                        NULL,
   max_flight_hieght  smallint                        NOT NULL,
   speed                smallint                        NOT NULL,
   max_weight         smallint                        NOT NULL,
   CONSTRAINT PK_TYPE_AIRPALNE PRIMARY KEY (id_type)
);

--ограничения
ALTER TABLE type_airplane
ADD CONSTRAINT CHECK_AIRPLANE_FLIGHT_LENGHT CHECK (flight_lenght>10);

ALTER TABLE type_airplane
ADD CONSTRAINT CHECK_AIRPLANE_MAX_FLIGHT_HEIGHT CHECK (max_flight_hieght>20);

ALTER TABLE type_airplane
ADD CONSTRAINT CHECK_AIRPLANE_SPEED CHECK (speed>0);

ALTER TABLE type_airplane
ADD CONSTRAINT CHECK_AIRPLANE_MAX_WEIGHT CHECK (max_weight>0);

/*==============================================================*/
/* Table: plane                                                 */
/*==============================================================*/
CREATE TABLE plane 
(
   board_number         serial				NOT NULL,
   id_type              integer                        NOT NULL,
   period_of_operation date                           NOT NULL,
   year_of_release   date                           NOT NULL,
   CONSTRAINT PK_PLANE PRIMARY KEY (board_number)
);

ALTER TABLE plane
   ADD CONSTRAINT FK_PLANE_TYPE_AIRPLANE FOREIGN KEY (id_type)
      REFERENCES type_airplane (id_type);

--ограничения
ALTER TABLE plane
	ADD CONSTRAINT CHECK_PERIOD_OF_OPERATION CHECK (
		EXTRACT(YEAR FROM period_of_operation) > 
		EXTRACT(YEAR FROM CURRENT_DATE) - 100);

ALTER TABLE plane
ADD CONSTRAINT CHECK_YEAR_OF_REALISE CHECK (
		EXTRACT(YEAR FROM year_of_release) > 
		EXTRACT(YEAR FROM CURRENT_DATE) - 100);

/*==============================================================*/
/* Table: country                                               */
/*==============================================================*/
CREATE TABLE country 
(
   id_country           serial                       NOT NULL,
   name_of_country    varchar(30)                       NOT NULL,
   CONSTRAINT PK_COUNTRY PRIMARY KEY(id_country)
);

/*==============================================================*/
/* Table: city                                                  */
/*==============================================================*/
CREATE TABLE city 
(
   id_city              serial                        NOT NULL,
   id_country           integer                        NOT NULL,
   name_of_city       varchar(50)                       NOT NULL,
   CONSTRAINT PK_CITY PRIMARY KEY(id_city)
);

ALTER TABLE city
   ADD CONSTRAINT FK_CITY_IS_LOCATE_COUNTRY FOREIGN KEY (id_country)
      REFERENCES country (id_country);

/*==============================================================*/
/* Table: airport                                     			*/
/*==============================================================*/
CREATE TABLE airport 
(
   id_airport           serial                       NOT NULL,
   id_city              integer                        NOT NULL,
   code                 smallint						NULL,
   name_of_airport    varchar(55)                    NOT NULL,
   CONSTRAINT PK_AIRPORT PRIMARY KEY (id_airport)
);

ALTER TABLE airport
   ADD CONSTRAINT FK_AIRPORT_CITY FOREIGN KEY (id_city)
      REFERENCES city (id_city);

/*==============================================================*/
/* Table: equipage                                              */
/*==============================================================*/
CREATE TABLE equipage 
(
   id_equipage          serial                        NOT NULL,
   flight_zone        varchar(50)                    NOT NULL,
   CONSTRAINT PK_EQUIPAGE PRIMARY KEY (id_equipage)
);

/*==============================================================*/
/* Table: post                                                  */
/*==============================================================*/
CREATE TABLE post 
(
   id_post              serial                       NOT NULL,
   name_of_post       varchar(20)                    NOT NULL,
   CONSTRAINT PK_POST PRIMARY KEY (id_post)
);

/*==============================================================*/
/* Table: street                                                */
/*==============================================================*/
CREATE TABLE street 
(
   id_street            serial                        NOT NULL,
   id_city              integer                        NOT NULL,
   name_of_street     varchar(100)                   NOT NULL,
   CONSTRAINT PK_STREET PRIMARY KEY (id_street)
);

ALTER TABLE street
   ADD CONSTRAINT FK_STREET_INCLUDED__CITY FOREIGN KEY (id_city)
      REFERENCES city (id_city);

/*==============================================================*/
/* Table: employee                                              */
/*==============================================================*/
CREATE TABLE employee 
(
   id_employee          serial                       NOT NULL,
   id_equipage          integer                        NULL,
   id_post              integer                        NOT NULL,
   id_street            integer                        NOT NULL,
   passport_series_and_number varchar(10)                    NOT NULL,
   surname_employee    varchar(20)                    NOT NULL,
   name_employee       varchar(20)                    NOT NULL,
   patronymic_employee varchar(20)                    NULL,
   employee_birthday   date                           NOT NULL,
   phone_employee      varchar(12)                    NOT NULL,
   date_of_entry_into_position date                           NOT NULL,
   date_of_leaving_position date                     NULL,
   home_employer      varchar(10)                    NOT NULL,
   flat_employer      smallint                        NULL,
   CONSTRAINT PK_EMPLOYEE PRIMARY KEY (id_employee)
);

ALTER TABLE employee
   ADD CONSTRAINT FK_EMPLOYEE_LIVES_STREET FOREIGN KEY (id_street)
      REFERENCES street (id_street);

ALTER TABLE employee
   ADD CONSTRAINT FK_EMPLOYEE_RESPOND_POST FOREIGN KEY (id_post)
      REFERENCES post (id_post);

ALTER TABLE employee
   ADD CONSTRAINT FK_EMPLOYEE_WORKS_EQUIPAGE FOREIGN KEY (id_equipage)
      REFERENCES equipage (id_equipage);

--ограничения
ALTER TABLE employee
	ADD CONSTRAINT CHECK_DATE_EMPLOYEE CHECK (
		EXTRACT(YEAR FROM employee_birthday) > 
		EXTRACT(YEAR FROM CURRENT_DATE) - 65);

ALTER TABLE employee
	ADD CONSTRAINT CHECK_NUMBER_FLAT_EMPLOYER CHECK (flat_employer > 0);

/*==============================================================*/
/* Table: flight                                                */
/*==============================================================*/
CREATE TABLE flight 
(
   id_flight            serial                        NOT NULL,
   id_equipage          integer                        NOT NULL,
   id_airport_start     integer                        NOT NULL,
   id_airport_finish    integer                        NOT NULL,
   board_number			integer							NOT NULL,
   date_and_time_start timestamp                       NOT NULL,
   date_and_time_finish timestamp                       NOT NULL,
   CONSTRAINT PK_FLIGHT PRIMARY KEY(id_flight)
);

ALTER TABLE flight
   ADD CONSTRAINT FK_FLIGHT_ARRIVES_AIRPORT FOREIGN KEY (id_airport_start)
      REFERENCES airport (id_airport);

ALTER TABLE flight
   ADD CONSTRAINT FK_FLIGHT_AWAY_AIRPORT FOREIGN KEY (id_airport_finish)
      REFERENCES airport (id_airport);

ALTER TABLE flight
   ADD CONSTRAINT FK_FLIGHT_WORKS_ON_EQUIPAGE FOREIGN KEY (id_equipage)
      REFERENCES equipage (id_equipage);
	  
ALTER TABLE flight
   ADD CONSTRAINT FK_FLIGHT_FLY_ON_PLANE FOREIGN KEY (board_number)
      REFERENCES plane (board_number);
	  
--ограничения
ALTER TABLE flight
	ADD CONSTRAINT CHECK_ONE_DAY CHECK (
		EXTRACT(DAY FROM date_and_time_finish) -
		EXTRACT(DAY FROM date_and_time_start) < 2);

ALTER TABLE flight
	ADD Constraint CHECK_DATE_AND_TIME CHECK (
		date_and_time_finish > date_and_time_start);

/*==============================================================*/
/* Table: passenger                                             */
/*==============================================================*/
CREATE TABLE passenger 
(
   id_passenger         serial                        NOT NULL,
   id_street            integer                        NOT NULL,
   passport_series_and_number varchar(10)                    NOT NULL,
   birthday_passenger date                      NOT NULL,
   surname_passenger  varchar(50)                    NOT NULL,
   name_passenger     varchar(50)                    NOT NULL,
   patronimic_passenger varchar(50)                    NULL,
   home_passenger     varchar(10)                    NOT NULL,
   flat_passenger     smallint                       NULL,
   CONSTRAINT PK_PASSENGER PRIMARY KEY(id_passenger)
);

ALTER TABLE passenger
   ADD CONSTRAINT FK_PASSENGE_LIVES_2_STREET FOREIGN KEY (id_street)
      REFERENCES street (id_street);

--ограничения
ALTER TABLE passenger
	ADD CONSTRAINT CHECK_DATE_PASSENGER CHECK (
		EXTRACT(YEAR FROM birthday_passenger) > 
		EXTRACT(YEAR FROM CURRENT_DATE) - 100);

ALTER TABLE passenger
	ADD CONSTRAINT CHECK_NUMBER_FLAT_PASSENGER CHECK (flat_passenger > 0);

/*==============================================================*/
/* Table: ticket                                                */
/*==============================================================*/
CREATE TABLE ticket 
(
   id_ticket            serial                       NOT NULL,
   id_flight            integer                        NOT NULL,
   id_passenger         integer                        NOT NULL,
   cost                 numeric                        NOT NULL,
   "row"                  smallint                        NOT NULL,
   "site"                 smallint                        NOT NULL,
   "class"               varchar(20)                    NOT NULL,
   type_of_baggage    varchar(20)                    NULL,
   weight_of_baggage  smallint                        NULL,
   CONSTRAINT PK_TICKET PRIMARY KEY(id_ticket)
);

ALTER TABLE ticket
   ADD CONSTRAINT FK_TICKET_EXISTING_FLIGHT FOREIGN KEY (id_flight)
      REFERENCES flight (id_flight);

ALTER TABLE ticket
   ADD CONSTRAINT FK_TICKET_OWNS_PASSENGE FOREIGN KEY (id_passenger)
      REFERENCES passenger (id_passenger);

--ограничения
ALTER TABLE ticket
	ADD CONSTRAINT CHECK_TICKET_ROW CHECK ("row"<500 AND "row">0);

ALTER TABLE ticket
	ADD CONSTRAINT CHECK_TICKET_SITE CHECK ("site"<2000 AND "site">0);
