
# Домашнее задание к занятию "6.2. SQL"
## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.
```
ea@ea-nb:~$ docker pull postgres:12

ea@ea-nb:~$ docker volume create database

database

ea@ea-nb:~$ docker volume create backup

backup

ea@ea-nb:~$ docker volume ls

DRIVER    VOLUME NAME

local     backup

local     database

ea@ea-nb:~$ docker run --name pg-docker -e POSTGRES_USER=pguser -e POSTGRES_PASSWORD=pa$$word -d -v database:/var/lib/postgres/data -v backup:/var/lib/postgres/backup postgres:12

5038133025c0efb1c371a06691544fd60165184ce0c99e780b520aeedbf65cc4
```
ea@ea-nb:~$ docker ps
```
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS
PORTS      NAMES
5038133025c0   postgres:12   "docker-entrypoint.s…"   15 seconds ago   Up 14 seconds   5432/tcp   pg-docker
```
## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db



ea@ea-nb:~$ docker exec -it 5038133025c0 bash

root@5038133025c0:/# psql -U pguser
```
psql (12.11 (Debian 12.11-1.pgdg110+1))
Type "help" for help.

pguser=# \l
                              List of databases
   Name    | Owner  | Encoding |  Collate   |   Ctype    | Access privileges
-----------+--------+----------+------------+------------+-------------------
 pguser    | pguser | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | pguser | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | pguser | UTF8     | en_US.utf8 | en_US.utf8 | =c/pguser        +
           |        |          |            |            | pguser=CTc/pguser
 template1 | pguser | UTF8     | en_US.utf8 | en_US.utf8 | =c/pguser        +
           |        |          |            |            | pguser=CTc/pguser
(4 rows)
```

```
pguser=# CREATE DATABASE test_bd;
CREATE DATABASE
pguser=# CREATE ROLE "test-admin-user" SUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;
CREATE ROLE
test_bd=# CREATE TABLE orders(
test_bd(# id SERIAL PRIMARY KEY,
test_bd(# name text,
test_bd(# price integer);
CREATE TABLE

test_bd=# CREATE TABLE clients (
id SERIAL PRIMARY KEY,
lastname text,
country text, booking integer,
FOREIGN KEY (booking) REFERENCES orders (id)
);
CREATE TABLE

test_bd=# CREATE ROLE "test-simple-user" NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;
test_bd=# GRANT SELECT ON TABLE public.clients TO "test-simple-user";
test_bd=# GRANT INSERT ON TABLE public.clients TO "test-simple-user";
test_bd=# GRANT UPDATE ON TABLE public.clients TO "test-simple-user";
test_bd=# GRANT DELETE ON TABLE public.clients TO "test-simple-user";
test_bd=# GRANT SELECT ON TABLE public.orders TO "test-simple-user";
test_bd=# GRANT INSERT ON TABLE public.orders TO "test-simple-user";
test_bd=# GRANT UPDATE ON TABLE public.orders TO "test-simple-user";
test_bd=# GRANT DELETE ON TABLE public.orders TO "test-simple-user
test_bd=# \d
              List of relations
 Schema |      Name      |   Type   | Owner
--------+----------------+----------+--------
 public | clients        | table    | pguser
 public | clients_id_seq | sequence | pguser
 public | orders         | table    | pguser
 public | orders_id_seq  | sequence | pguser
(4 rows)

test_bd=# \d clients
                             Table "public.clients"
  Column  |  Type   | Collation | Nullable |               Default
----------+---------+-----------+----------+-------------------------------------
 id       | integer |           | not null | nextval('clients_id_seq'::regclass)
 lastname | text    |           |          |
 country  | text    |           |          |
 booking  | integer |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_booking_fkey" FOREIGN KEY (booking) REFERENCES orders(id)

test_bd=# \d orders
                            Table "public.orders"
 Column |  Type   | Collation | Nullable |              Default
--------+---------+-----------+----------+------------------------------------
 id     | integer |           | not null | nextval('orders_id_seq'::regclass)
 name   | text    |           |          |
 price  | integer |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_booking_fkey" FOREIGN KEY (booking) REFERENCES orders(id)


test_bd=# \du
                                       List of roles
    Role name     |                         Attributes                         | Member of
------------------+------------------------------------------------------------+-----------
 pguser           | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 test-admin-user  | Superuser, No inheritance                                  | {}
 test-simple-user | No inheritance                                             | {}


test_bd=# SELECT * FROM information_schema.table_privileges where grantee in ('test-admin-user', 'test-simple-user');
 grantor |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
---------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 pguser  | test-simple-user | test_bd       | public       | clients    | INSERT         | NO           | NO
 pguser  | test-simple-user | test_bd       | public       | clients    | SELECT         | NO           | YES
 pguser  | test-simple-user | test_bd       | public       | clients    | UPDATE         | NO           | NO
 pguser  | test-simple-user | test_bd       | public       | clients    | DELETE         | NO           | NO
 pguser  | test-simple-user | test_bd       | public       | orders     | INSERT         | NO           | NO
 pguser  | test-simple-user | test_bd       | public       | orders     | SELECT         | NO           | YES
 pguser  | test-simple-user | test_bd       | public       | orders     | UPDATE         | NO           | NO
 pguser  | test-simple-user | test_bd       | public       | orders     | DELETE         | NO           | NO
(8 rows)

test_bd=# \dt
         List of relations
 Schema |  Name   | Type  | Owner
--------+---------+-------+--------
 public | clients | table | pguser
 public | orders  | table | pguser
(2 rows)
```
## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.
```
test_bd=# insert into clients (lastname, country) values
test_bd-# ('Иванов Иван Иванович', 'USA'),
test_bd-# ('Петров Петр Петрович', 'Canada'),
test_bd-# ('Иоганн Себастьян Бах', 'Japan'),
test_bd-# ('Ронни Джеймс Дио', 'Russia'),
test_bd-# ('Ritchie Blackmore', 'Russia');
INSERT 0 5

test_bd=# select * from clients;
 id |       lastname       | country | booking
----+----------------------+---------+---------
  1 | Иванов Иван Иванович | USA     |
  2 | Петров Петр Петрович | Canada  |
  3 | Иоганн Себастьян Бах | Japan   |
  4 | Ронни Джеймс Дио     | Russia  |
  5 | Ritchie Blackmore    | Russia  |
(5 rows)

test_bd=# insert into orders (name, price) values 
test_bd-# ('Шоколад', 10)
test_bd-# ('Принтер', 3000),
test_bd-# ('Книга', 500),
test_bd-# ('Монитор', 7000),
test_bd-# ('Гитара', 4000);

test_bd=# select *  from orders;
 id |  name   | price
----+---------+-------
  1 | Шоколад |    10
  2 | Принтер |  3000
  3 | Книга   |   500
  4 | Монитор |  7000
  5 | Гитара  |  4000
(5 rows)

test_bd=# select count(*) from clients;
 count
-------
     5
(1 row)

test_bd=# select count(*) from orders;
 count
-------
     5
(1 row)
```
## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

```

test_bd=# update clients set booking = 3 where lastname = 'Иванов Иван Иванович';
UPDATE 1
test_bd=# update clients set booking = (select id from orders where name = 'Гитара') wh
ere lastname = 'Иоганн Себастьян Бах';
UPDATE 1
test_bd=#  update clients set booking = (select id from orders where name = 'Монитор')
where lastname = 'Петров Петр Петрович';
UPDATE 1
test_bd=# select lastname from clients where booking is not null;
       lastname
----------------------
 Иванов Иван Иванович
 Иоганн Себастьян Бах
 Петров Петр Петрович
(3 rows)
```
## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.
```
test_bd=# explain select lastname from clients where booking is not null;
                        QUERY PLAN
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=32)
   Filter: (booking IS NOT NULL)
(2 rows)


Показывает стоимость(нагрузку на исполнение) запроса , и фильтрацию по полю Booking для выборки.
```

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.
```
docker exec -t pg-docker pg_dump -U pguser test_bd -f /var/lib/postgres/backup/dump.sql
docker exec -i pg-docker-restore psql -U pguser -f /var/lib/postgres/backup/dump.sql

SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
psql:/var/lib/postgres/backup/dump.sql:118: ERROR:  invalid input syntax for type integer: "4       Ронни Джеймс Дио        Russia  N"
CONTEXT:  COPY clients, line 1, column id: "4       Ронни Джеймс Дио        Russia  N"
psql:/var/lib/postgres/backup/dump.sql:131: ERROR:  invalid input syntax for type integer: "1       Шоколад 10"
CONTEXT:  COPY orders, line 1, column id: "1       Шоколад 10"
 setval
--------
      5
(1 row)

 setval
--------
      5
(1 row)

ALTER TABLE
ALTER TABLE
ALTER TABLE

```