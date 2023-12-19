/*
Открыть две psql консоли, подключится к БД db_airline.
1 user - это первая консоль
2 user - это вторая консоль
Вводить почереди в разные консоли. Например, сначала в 1 консоль
вводим: BEGIN;
SELECT *, xmin, xmax FROM post;
потом во вторую: BEGIN;
SELECT *, xmin, xmax FROM post;
снова в 1 консоль: UPDATE post SET name_of_post = 'Multiversion' WHERE name_of_post LIKE 'test1%';
SELECT *, xmin, xmax FROM post;
и т.д.
*/

--first_part Многоверсионность
--1 user
BEGIN;
SELECT *, xmin, xmax FROM post;
--2 user
BEGIN;
SELECT *, xmin, xmax FROM post;
--1 user
UPDATE post SET name_of_post = 'test1 Multiversion' WHERE name_of_post LIKE 'test1%';
SELECT *, xmin, xmax FROM post;
--2 user
SELECT *, xmin, xmax FROM post;
--1 user
COMMIT;
SELECT *, xmin, xmax FROM post;
-- 2 user
SELECT *, xmin, xmax FROM post;
COMMIT;

--second_part Конфликт блокировок
--1 user
BEGIN;
UPDATE post SET name_of_post = 'test1 Lock 1 user' WHERE name_of_post LIKE 'test1%';
SELECT *, xmin, xmax FROM post;
--2 user
BEGIN;
UPDATE post SET name_of_post = 'test1 Lock 2 user' WHERE name_of_post LIKE 'test1%';
SELECT *, xmin, xmax FROM post;
--1 user
COMMIT;
SELECT *, xmin, xmax FROM post;
--2 user
COMMIT;
SELECT *, xmin, xmax FROM post;

--third_part Дедлок
--1 user
BEGIN;
SELECT *, xmin, xmax FROM post;
UPDATE post SET name_of_post = 'test1 Дедлок 1 user' WHERE name_of_post LIKE 'test1%';
SELECT *, xmin, xmax FROM post;
--2 user
BEGIN;
SELECT *, xmin, xmax FROM post;
UPDATE post SET name_of_post = 'test2 Дедлок 2 user' WHERE name_of_post LIKE 'test2%';
SELECT *, xmin, xmax FROM post;
--1 user
UPDATE post SET name_of_post = 'test2 Дедлок 1 user' WHERE name_of_post LIKE 'test2%';
--2 user
UPDATE post SET name_of_post = 'test1 Дедлок 2 user' WHERE name_of_post LIKE 'test1%';
/*
ОШИБКА:  обнаружена взаимоблокировка
ПОДРОБНОСТИ:  Процесс 13628 ожидает в режиме ShareLock блокировку "транзакция 1122"; заблокирован процессом 11620.
Процесс 11620 ожидает в режиме ShareLock блокировку "транзакция 1123"; заблокирован процессом 13628.
ПОДСКАЗКА:  Подробности запроса смотрите в протоколе сервера.
КОНТЕКСТ:  при изменении кортежа (0,9) в отношении "post"
*/
--1 user
SELECT *, xmin, xmax FROM post;
COMMIT;
--2 user
ROLLBACK;
