# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.
```buildoutcfg
FROM centos:7
RUN yum install wget -y
RUN yum install curl -y
ENV PATH=/usr/lib:/usr/lib/jvm/jre-11/bin:$PATH

RUN yum install java-11-openjdk -y

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.5-lin>    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.5->RUN yum install perl-Digest-SHA -y
RUN shasum -a 512 -c elasticsearch-7.17.5-linux-x86_64.tar.gz.sha512 \
    && tar -xzf elasticsearch-7.17.5-linux-x86_64.tar.gz

COPY elasticsearch.yml /elasticsearch-7.17.5/config/
ENV JAVA_HOME=/elasticsearch-7.17.5/jdk/
ENV ES_HOME=/elasticsearch-7.17.5
RUN groupadd elasticsearch \
    && useradd -g elasticsearch elasticsearch

RUN mkdir /var/lib/logs \
    && chown elasticsearch:elasticsearch /var/lib/logs \
    && mkdir /var/lib/data \
    && chown elasticsearch:elasticsearch /var/lib/data \
    && chown -R elasticsearch:elasticsearch /elasticsearch-7.17.5/
RUN mkdir /elasticsearch-7.17.5/snapshots &&\
    chown elasticsearch:elasticsearch /elasticsearch-7.17.5/snapshots

USER elasticsearch
CMD ["/usr/sbin/init"]
CMD ["/elasticsearch-7.17.5/bin/elasticsearch"]
```

https://hub.docker.com/r/belnik/eld

```buildoutcfg
ea@ea-nb:~$ curl -X GET "localhost:9200/?pretty"
{
  "name" : "netology_test",
  "cluster_name" : "docker-cluster",
  "cluster_uuid" : "dlYPfOm2Rm-e-ARX-2EFFw",
  "version" : {
    "number" : "7.17.5",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "8d61b4f7ddf931f219e3745f295ed2bbc50c8e84",
    "build_date" : "2022-06-23T21:57:28.736740635Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```


## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |
```buildoutcfg
ea@ea-nb:~$ curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas"
: 0, "number_of_shards": 1}}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}
ea@ea-nb:~$ curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas"
: 1, "number_of_shards": 2}}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}
ea@ea-nb:~$ curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas"
: 2, "number_of_shards": 4}}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}
```

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.
```buildoutcfg
ea@ea-nb:~$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases YDet8Q84Q1uFcWrNBguUCg   1   0         40            0       38mb           38mb
green  open   ind-1            rDLFocauQsaEoHYDQb5ahA   1   0          0            0       226b           226b
yellow open   ind-3            Ol9l29KJTuehcBZeVqPQsw   4   2          0            0       904b           904b
yellow open   ind-2            1BuAX53fQSyQy5Zh3eDtbw   2   1          0            0       452b           452b
```
```buildoutcfg
ea@ea-nb:~$ curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty'
{
  "cluster_name" : "docker-cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
ea@ea-nb:~$ curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "docker-cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
ea@ea-nb:~$ curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "docker-cluster",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
```
Получите состояние кластера `elasticsearch`, используя API.
```buildoutcfg
ea@ea-nb:~$ curl -X GET 'http://localhost:9200/_cluster/health/?pretty=true'
{
  "cluster_name" : "docker-cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
```
Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
```buildoutcfg
Индексы ind-2 и ind-3 в статусе Yellow т.к.  число реплик меньше числа серверов, невозможно реплицировать.
```
Удалите все индексы.
```buildoutcfg
ea@ea-nb:~$ curl -X DELETE 'http://localhost:9200/ind-1?pretty'
{
  "acknowledged" : true
}
ea@ea-nb:~$ curl -X DELETE 'http://localhost:9200/ind-2?pretty'
{
  "acknowledged" : true
}
ea@ea-nb:~$ curl -X DELETE 'http://localhost:9200/ind-3?pretty'
{
  "acknowledged" : true
}
ea@ea-nb:~$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases YDet8Q84Q1uFcWrNBguUCg   1   0         40            0       38mb           38mb
```
**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.
```buildoutcfg
ea@ea-nb:~$ curl -X PUT "localhost:9200/_snapshot/netology_backup?verify=false&pretty" -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/elasticsearch-7.17.5/snapshots/" }}'
{
  "acknowledged" : true
}
ea@ea-nb:~$ curl http://localhost:9200/_snapshot/netology_backup?pretty
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/elasticsearch-7.17.5/snapshots/"
    }
  }
}
ea@ea-nb:~$ curl http://localhost:9200/_snapshot/netology_backup?pretty
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/elasticsearch-7.17.5/snapshots"
    }
  }
}
```
**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.
```buildoutcfg
ea@ea-nb:~$ curl -X PUT localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}
ea@ea-nb:~$ curl -X DELETE 'http://localhost:9200/test?pretty'application/jsoGET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases W6R-zdVuS4mLZtJ8rUmt5g   1   0         40            0     37.9mb         37.9mb
green  open   test             uTbes4AiRP2CLnMCsnY_dA   1   0          0            0       226b           226b
ea@ea-nb:~$ curl http://localhost:9200/test?pretty
{
  "test" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "test",
        "creation_date" : "1657750215382",
        "number_of_replicas" : "0",
        "uuid" : "uTbes4AiRP2CLnMCsnY_dA",
        "version" : {
          "created" : "7170599"
        }
      }
    }
  }
}
```
[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.
```buildoutcfg
ea@ea-nb:~$ curl -X PUT "localhost:9200/_snapshot/netology_backup/backup?wait_for_completion=true&pretty"
{
  "snapshot" : {
    "snapshot" : "backup",
    "uuid" : "oyzIC24DQBaMHzvU07Jf9A",
    "repository" : "netology_backup",
    "version_id" : 7170599,
    "version" : "7.17.5",
    "indices" : [
      ".geoip_databases",
      ".ds-.logs-deprecation.elasticsearch-default-2022.07.07-000001",
      "test",
      ".ds-ilm-history-5-2022.07.07-000001"
    ],
    "data_streams" : [
      "ilm-history-5",
      ".logs-deprecation.elasticsearch-default"
    ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2022-07-13T22:15:49.765Z",
    "start_time_in_millis" : 1657750549765,
    "end_time" : "2022-07-13T22:15:51.166Z",
    "end_time_in_millis" : 1657750551166,
    "duration_in_millis" : 1401,
    "failures" : [ ],
    "shards" : {
      "total" : 4,
      "failed" : 0,
      "successful" : 4
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      }
    ]
  }
}
```
```buildoutcfg
[elasticsearch@eb81b2036aac snapshots]$ ls -la
total 68
drwxr-xr-x 1 elasticsearch elasticsearch  4096 Jul 13 22:15 .
drwxr-xr-x 1 elasticsearch elasticsearch  4096 Jul  7 21:26 ..
-rw-r--r-- 1 elasticsearch elasticsearch  1418 Jul 13 22:15 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Jul 13 22:15 index.latest
drwxr-xr-x 6 elasticsearch elasticsearch  4096 Jul 13 22:15 indices
-rw-r--r-- 1 elasticsearch elasticsearch 29300 Jul 13 22:15 meta-oyzIC24DQBaMHzvU07Jf9A.dat
drwxr-xr-x 2 elasticsearch elasticsearch  4096 Jul  7 21:55 my_fs_backup_location
drwxrwxr-x 2 elasticsearch elasticsearch  4096 Jul 13 22:03 netology_backup
-rw-r--r-- 1 elasticsearch elasticsearch   705 Jul 13 22:15 snap-oyzIC24DQBaMHzvU07Jf9A.dat
```
**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.
```buildoutcfg
ea@ea-nb:~$ curl -X DELETE 'http://localhost:9200/test?pretty'
{
  "acknowledged" : true
}
ea@ea-nb:~$ curl -X PUT localhost:9200/test2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test2"}
ea@ea-nb:~$ curl -X DELETE 'http://localhost:9200/test?pea@ea-nb:~$ catio-X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases W6R-zdVuS4mLZtJ8rUmt5g   1   0         40            0     37.9mb         37.9mb
green  open   test2            d6d_001RQECxQWBMTPiOoQ   1   0          0            0       226b           226b
```
[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 
```buildoutcfg
ea@ea-nb:~$ curl -X POST "localhost:9200/_snapshot/netology_backup/backup/_restore?pretty" -H 'Content-Type: application/json' -d'
{
  "indices": "test"
}
'
{
  "accepted" : true
}
ea@ea-nb:~$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases W6R-zdVuS4mLZtJ8rUmt5g   1   0         40            0     37.9mb         37.9mb
green  open   test2            d6d_001RQECxQWBMTPiOoQ   1   0          0            0       226b           226b
green  open   test             js74d7v6QaCPzh4J-yAkdQ   1   0          0            0       226b           226b
```
**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---