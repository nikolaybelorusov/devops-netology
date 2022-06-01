# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
```
Global - реплика будет развернута на всех нодах
Replication - необходимо задать число микросервисов в кластере
```
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
```
Для определения лидера в Docker Swarm используется RAFT-алгоритм  
```
- Что такое Overlay Network?
```
Overlay Network обеспечивает взаимодействие Docker Swarm служб множества Docker внутри кластера 
```

## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls
```

![alt text](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/5.5/2.PNG)

## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls
```

![alt text](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/5.5/3.PNG)
## Задача 4 (*)

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```