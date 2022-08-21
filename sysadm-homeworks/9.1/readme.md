# Домашнее задание к занятию "09.01 Жизненный цикл ПО"

## Подготовка к выполнению
1. Получить бесплатную [JIRA](https://www.atlassian.com/ru/software/jira/free)
2. Настроить её для своей "команды разработки"
3. Создать доски kanban и scrum
```buildoutcfg
Выполнено
```
## Основная часть
В рамках основной части необходимо создать собственные workflow для двух типов задач: bug и остальные типы задач. Задачи типа bug должны проходить следующий жизненный цикл:
1. Open -> On reproduce
2. On reproduce <-> Open, Done reproduce
3. Done reproduce -> On fix
4. On fix <-> On reproduce, Done fix
5. Done fix -> On test
6. On test <-> On fix, Done
7. Done <-> Closed, Open
```buildoutcfg
Выполнено
```
Остальные задачи должны проходить по упрощённому workflow:
1. Open -> On develop
2. On develop <-> Open, Done develop
3. Done develop -> On test
4. On test <-> On develop, Done
5. Done <-> Closed, Open
```buildoutcfg
Выполнено
```
Создать задачу с типом bug, попытаться провести его по всему workflow до Done. Создать задачу с типом epic, к ней привязать несколько задач с типом task, провести их по всему workflow до Done. При проведении обеих задач по статусам использовать kanban. Вернуть задачи в статус Open.
Перейти в scrum, запланировать новый спринт, состоящий из задач эпика и одного бага, стартовать спринт, провести задачи до состояния Closed. Закрыть спринт.
```buildoutcfg
Выполнено
```
![alt text](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/9.1/img/Kanban.JPG)
![alt text](https://github.com/nikolaybelorusov/devops-netology/blob/a957f2fd328ee27759b548269332a8a5f344765d/sysadm-homeworks/9.1/img/Sprint.JPG)
![alt text](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/9.1/img/Sprint2.JPG)
[workflow for bugs](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/9.1/for%20bugs.xml)

[workflow all tasks](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/9.1/all%20tasks%20(1).xml)

Если всё отработало в рамках ожидания - выгрузить схемы workflow для импорта в XML. Файлы с workflow приложить к решению задания.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---