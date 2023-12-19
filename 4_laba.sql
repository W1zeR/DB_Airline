/* Выбрать id страны с наибольшим количеством
городов */

-- 1 вариант
EXPLAIN ANALYZE WITH CTE AS
(
	SELECT c.id_country, COUNT(*) cities
	FROM city c
	GROUP BY c.id_country
)
SELECT c.id_country
FROM CTE c
WHERE c.cities =
	(SELECT MAX(c1.cities)
	FROM CTE c1);

/*
 CTE Scan on cte c  (cost=21.61..26.11 rows=1 width=4) (actual time=0.033..0.034 rows=1 loops=1)
   Filter: (cities = $1)
   Rows Removed by Filter: 1
   CTE cte
     ->  HashAggregate  (cost=15.10..17.10 rows=200 width=12) (actual time=0.026..0.027 rows=2 loops=1)
           Group Key: c_1.id_country
           Batches: 1  Memory Usage: 40kB
           ->  Seq Scan on city c_1  (cost=0.00..13.40 rows=340 width=4) (actual time=0.017..0.018 rows=3 loops=1)
   InitPlan 2 (returns $1)
     ->  Aggregate  (cost=4.50..4.51 rows=1 width=8) (actual time=0.003..0.004 rows=1 loops=1)
           ->  CTE Scan on cte c1  (cost=0.00..4.00 rows=200 width=8) (actual time=0.000..0.002 rows=2 loops=1)
 Planning Time: 2.022 ms
 Execution Time: 0.179 ms
(13 строк)
*/

-- 2 вариант
EXPLAIN ANALYZE SELECT c.id_country
FROM city c
GROUP BY c.id_country
HAVING COUNT(*) >= ALL
	(SELECT COUNT(*)
	FROM city c1
	GROUP BY c1.id_country);
	
/*
 HashAggregate  (cost=30.20..382.70 rows=100 width=4) (actual time=0.030..0.031 rows=1 loops=1)
   Group Key: c.id_country
   Filter: (SubPlan 1)
   Batches: 1  Memory Usage: 40kB
   Rows Removed by Filter: 1
   ->  Seq Scan on city c  (cost=0.00..13.40 rows=340 width=4) (actual time=0.010..0.010 rows=3 loops=1)
   SubPlan 1
     ->  Materialize  (cost=15.10..18.10 rows=200 width=12) (actual time=0.005..0.005 rows=2 loops=2)
           ->  HashAggregate  (cost=15.10..17.10 rows=200 width=12) (actual time=0.007..0.008 rows=2 loops=1)
                 Group Key: c1.id_country
                 Batches: 1  Memory Usage: 40kB
                 ->  Seq Scan on city c1  (cost=0.00..13.40 rows=340 width=4) (actual time=0.004..0.004 rows=3 loops=1)
 Planning Time: 0.135 ms
 Execution Time: 0.076 ms
(14 строк)
*/

/* Выбрать id сотрудников, которые младше среднего
возраста сотрудников по их городу */

-- 1 вариант
EXPLAIN ANALYZE SELECT e.id_employee
FROM employee e
JOIN street s ON e.id_street = s.id_street
WHERE date_part('year', age(e.employee_birthday)) <
	(SELECT AVG(date_part('year', age(e1.employee_birthday)))
	FROM employee e1
	JOIN street s1 ON e1.id_street = s1.id_street
	WHERE s.id_city = s1.id_city);

/*
 Hash Join  (cost=17.20..30.10 rows=77 width=4) (actual time=0.190..0.192 rows=1 loops=1)
   Hash Cond: (e.id_street = s.id_street)
   Join Filter: (date_part('year'::text, age((CURRENT_DATE)::timestamp with time zone, (e.employee_birthday)::timestamp with time zone)) < (SubPlan 1))
   Rows Removed by Join Filter: 3
   ->  Seq Scan on employee e  (cost=0.00..12.30 rows=230 width=12) (actual time=0.017..0.018 rows=4 loops=1)
   ->  Hash  (cost=13.20..13.20 rows=320 width=8) (actual time=0.048..0.048 rows=5 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 9kB
         ->  Seq Scan on street s  (cost=0.00..13.20 rows=320 width=8) (actual time=0.010..0.013 rows=5 loops=1)
   SubPlan 1
     ->  Aggregate  (cost=26.96..26.97 rows=1 width=8) (actual time=0.024..0.024 rows=1 loops=4)
           ->  Hash Join  (cost=14.03..26.94 rows=1 width=4) (actual time=0.016..0.017 rows=3 loops=4)
                 Hash Cond: (e1.id_street = s1.id_street)
                 ->  Seq Scan on employee e1  (cost=0.00..12.30 rows=230 width=8) (actual time=0.004..0.004 rows=4 loops=4)
                 ->  Hash  (cost=14.00..14.00 rows=2 width=4) (actual time=0.007..0.007 rows=1 loops=4)
                       Buckets: 1024  Batches: 1  Memory Usage: 9kB
                       ->  Seq Scan on street s1  (cost=0.00..14.00 rows=2 width=4) (actual time=0.002..0.003 rows=1 loops=4)
                             Filter: (s.id_city = id_city)
                             Rows Removed by Filter: 4
 Planning Time: 3.555 ms
 Execution Time: 0.255 ms
(20 строк)
*/

-- 2 вариант
EXPLAIN ANALYZE SELECT e.id_employee
FROM employee e
JOIN street s ON e.id_street = s.id_street
JOIN
	(SELECT s1.id_city, AVG(date_part('year', age(e1.employee_birthday))) avg_age
	FROM employee e1
	JOIN street s1 ON e1.id_street = s1.id_street
	GROUP BY s1.id_city) temp ON s.id_city = temp.id_city
WHERE date_part('year', age(e.employee_birthday)) < temp.avg_age;

/*
 Hash Join  (cost=58.34..71.86 rows=77 width=4) (actual time=0.111..0.113 rows=1 loops=1)
   Hash Cond: (s.id_city = s1.id_city)
   Join Filter: (date_part('year'::text, age((CURRENT_DATE)::timestamp with time zone, (e.employee_birthday)::timestamp with time zone)) < (avg(date_part('year'::text, age((CURRENT_DATE)::timestamp with time zone, (e1.employee_birthday)::timestamp with time zone)))))
   Rows Removed by Join Filter: 3
   ->  Hash Join  (cost=17.20..30.11 rows=230 width=12) (actual time=0.041..0.043 rows=4 loops=1)
         Hash Cond: (e.id_street = s.id_street)
         ->  Seq Scan on employee e  (cost=0.00..12.30 rows=230 width=12) (actual time=0.016..0.016 rows=4 loops=1)
         ->  Hash  (cost=13.20..13.20 rows=320 width=8) (actual time=0.014..0.014 rows=5 loops=1)
               Buckets: 1024  Batches: 1  Memory Usage: 9kB
               ->  Seq Scan on street s  (cost=0.00..13.20 rows=320 width=8) (actual time=0.007..0.008 rows=5 loops=1)
   ->  Hash  (cost=38.64..38.64 rows=200 width=12) (actual time=0.057..0.058 rows=2 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 9kB
         ->  HashAggregate  (cost=34.14..36.64 rows=200 width=12) (actual time=0.050..0.051 rows=2 loops=1)
               Group Key: s1.id_city
               Batches: 1  Memory Usage: 40kB
               ->  Hash Join  (cost=17.20..30.11 rows=230 width=8) (actual time=0.026..0.029 rows=4 loops=1)
                     Hash Cond: (e1.id_street = s1.id_street)
                     ->  Seq Scan on employee e1  (cost=0.00..12.30 rows=230 width=8) (actual time=0.004..0.004 rows=4 loops=1)
                     ->  Hash  (cost=13.20..13.20 rows=320 width=8) (actual time=0.014..0.014 rows=5 loops=1)
                           Buckets: 1024  Batches: 1  Memory Usage: 9kB
                           ->  Seq Scan on street s1  (cost=0.00..13.20 rows=320 width=8) (actual time=0.004..0.005 rows=5 loops=1)
 Planning Time: 0.432 ms
 Execution Time: 0.230 ms
(23 строки)
*/

/* Выбрать id пассажиров, которых зовут
так же, как и сотрудника с id = 2 */

-- 1 вариант
EXPLAIN ANALYZE SELECT p.id_passenger
FROM passenger  p
WHERE p.name_passenger LIKE 
	(SELECT e.name_employee
	FROM employee e
	WHERE e.id_employee = 2);

/*
 Seq Scan on passenger p  (cost=8.16..20.29 rows=1 width=4) (actual time=0.055..0.056 rows=2 loops=1)
   Filter: ((name_passenger)::text ~~ ($0)::text)
   Rows Removed by Filter: 2
   InitPlan 1 (returns $0)
     ->  Index Scan using pk_employee on employee e  (cost=0.14..8.16 rows=1 width=58) (actual time=0.011..0.012 rows=1 loops=1)
           Index Cond: (id_employee = 2)
 Planning Time: 2.007 ms
 Execution Time: 0.078 ms
(8 строк)
*/
	
-- 2 вариант
EXPLAIN ANALYZE SELECT p.id_passenger
FROM passenger p
JOIN employee e ON p.name_passenger LIKE e.name_employee
WHERE e.id_employee = 2;

/*
 Nested Loop  (cost=0.14..21.99 rows=1 width=4) (actual time=0.022..0.024 rows=2 loops=1)
   Join Filter: ((p.name_passenger)::text ~~ (e.name_employee)::text)
   Rows Removed by Join Filter: 2
   ->  Index Scan using pk_employee on employee e  (cost=0.14..8.16 rows=1 width=58) (actual time=0.006..0.007 rows=1 loops=1)
         Index Cond: (id_employee = 2)
   ->  Seq Scan on passenger p  (cost=0.00..11.70 rows=170 width=122) (actual time=0.011..0.011 rows=4 loops=1)
 Planning Time: 0.380 ms
 Execution Time: 0.045 ms
(8 строк)
*/