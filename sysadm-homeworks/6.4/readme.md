# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
```buildoutcfg
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)
```
- подключения к БД
``` buildoutcfg
postgres=# \c postgres
You are now connected to database "postgres" as user "postgres".
```
- вывода списка таблиц
```buildoutcfg
postgres=# \dtS
                    List of relations
   Schema   |          Name           | Type  |  Owner
------------+-------------------------+-------+----------
 pg_catalog | pg_aggregate            | table | postgres
 pg_catalog | pg_am                   | table | postgres
 pg_catalog | pg_amop                 | table | postgres
 pg_catalog | pg_amproc               | table | postgres
 pg_catalog | pg_attrdef              | table | postgres
 pg_catalog | pg_attribute            | table | postgres
 pg_catalog | pg_auth_members         | table | postgres
 pg_catalog | pg_authid               | table | postgres
 pg_catalog | pg_cast                 | table | postgres
 pg_catalog | pg_class                | table | postgres
 pg_catalog | pg_collation            | table | postgres
 pg_catalog | pg_constraint           | table | postgres
 ...
```
- вывода описания содержимого таблиц
```buildoutcfg
postgres=# \dS+ pg_database
                                   Table "pg_catalog.pg_database"
    Column     |   Type    | Collation | Nullable | Default | Storage  | Stats target |
 Description
---------------+-----------+-----------+----------+---------+----------+--------------+
-------------
 oid           | oid       |           | not null |         | plain    |              |

 datname       | name      |           | not null |         | plain    |              |

 datdba        | oid       |           | not null |         | plain    |              |

 encoding      | integer   |           | not null |         | plain    |              |

 datcollate    | name      |           | not null |         | plain    |              |

 datctype      | name      |           | not null |         | plain    |              |

 datistemplate | boolean   |           | not null |         | plain    |              |

 datallowconn  | boolean   |           | not null |         | plain    |              |

 datconnlimit  | integer   |           | not null |         | plain    |              |

 datlastsysoid | oid       |           | not null |         | plain    |              |

 datfrozenxid  | xid       |           | not null |         | plain    |              |

 datminmxid    | xid       |           | not null |         | plain    |              |

 dattablespace | oid       |           | not null |         | plain    |              |

 datacl        | aclitem[] |           |          |         | extended |              |

Indexes:
    "pg_database_datname_index" UNIQUE, btree (datname), tablespace "pg_global"
    "pg_database_oid_index" UNIQUE, btree (oid), tablespace "pg_global"
Tablespace: "pg_global"
Access method: heap
```
- выхода из psql
```buildoutcfg
postgres=# \q
root@898467f0943e:/#
```


## Задача 2

Используя `psql` создайте БД `test_database`.
```buildoutcfg
root@898467f0943e:/# psql -U postgres
psql (13.7 (Debian 13.7-1.pgdg110+1))
Type "help" for help.

postgres=# create database test_database;
CREATE DATABASE
```
Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.
```buildoutcfg
root@898467f0943e:/# psql -U postgres -f /var/lib/postgres/backup/test_dump.sql test_da
tabase
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
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
```
Перейдите в управляющую консоль `psql` внутри контейнера.
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
```buildoutcfg
postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)

test_database=# ANALYZE VERBOSE public.orders ;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```
Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.
```buildoutcfg
test_database=# select avg_width from pg_stats where tablename='orders';
 avg_width
-----------
         4
        16
         4
(3 rows)

```
**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.
```buildoutcfg
test_database=# alter table orders rename to orders_templ;
ALTER TABLE
test_database=# create table orders (id integer, title varchar(80), price integer) partition by range(price);
CREATE TABLE
test_database=# create table orders_2 partition of orders for values from (0) to (499);
CREATE TABLE
test_database=# create table orders_1 partition of orders for values from (499) to (999999);
CREATE TABLE
test_database=# insert into orders (id, title, price) select * from orders_templ;
INSERT 0 8
test_database=# select * from orders;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  2 | My little database   |   500
  6 | WAL never lies       |   900
  7 | Me and my bash-pet   |   499
  8 | Dbiezdmin            |   501
(8 rows)

test_database=# select * from orders_2;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
(4 rows)

test_database=# select * from orders_1;
 id |       title        | price
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  7 | Me and my bash-pet |   499
  8 | Dbiezdmin          |   501
(4 rows)

```
Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.
```buildoutcfg
root@898467f0943e:/# pg_dump -U postgres -d test_database > /var/lib/postgres/backup/te
st_database_dump.sql
```
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

```buildoutcfg
ALTER TABLE orders_2 ADD UNIQUE (title);
ALTER TABLE orders_1 ADD UNIQUE (title);
```
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---