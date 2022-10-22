# Дипломная работа
## 1. Регистрация доменного имени
Домен зарегистрирован, настроено делегирование DNS
![img](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/diplom/screenshots/domain/dom.JPG)
## 2. Создание инфраструктуры
Вся необходимая инфрастуктура создана с помощью [Terraform](https://github.com/nikolaybelorusov/devops-netology/tree/main/sysadm-homeworks/diplom/terraform)
![img_17.png](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/diplom/screenshots/Yc/yc.JPG)
Созданы 2 workspace
```commandline
ea@ea-nb:~/eadipl/terra$ terraform workspace list
  default
* prod
  stage
```

## 3. Установка Nginx и LetsEncrypt
1. Роль [nginx](https://github.com/nikolaybelorusov/devops-netology/tree/main/sysadm-homeworks/diplom/ansible/roles/nginx)
2. В доменной зоне настроены A-записи
![img_16.png](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/diplom/screenshots/Yc/dns.JPG)
3. Установлен Nginx и LetsEncrypt
4. Настроен reverse proxy с поддержкой TLS для обеспечения безопасного доступа к веб-сервисам по HTTPS.
5. Скриншоты сертификатов
![img_11.png](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/diplom/screenshots/cert/www.JPG)
![img_12.png](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/diplom/screenshots/cert/alert.JPG)
![img_13.png](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/diplom/screenshots/cert/grafana.JPG)
![img_14.png](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/diplom/screenshots/cert/prom.JPG)
![img_15.png](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/diplom/screenshots/cert/gitlab.JPG)
## 4. Установка кластера MySQL
1. Роли [db_master](https://github.com/nikolaybelorusov/devops-netology/tree/main/sysadm-homeworks/diplom/ansible/roles/db_master/tasks), [db_slave](https://github.com/nikolaybelorusov/devops-netology/tree/main/sysadm-homeworks/diplom/ansible/roles/db_slave/tasks)
2. Кластер Mysql настроен в режиме Master/Slave
![img_9.png](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/diplom/screenshots/DB/slave.JPG)
3. Создана база wordpress, ее использует web-сервер с Wordpress (задание 5) 
```commandline
mysql> use wordpress;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-----------------------+
| Tables_in_wordpress   |
+-----------------------+
| wp_commentmeta        |
| wp_comments           |
| wp_links              |
| wp_options            |
| wp_postmeta           |
| wp_posts              |
| wp_term_relationships |
| wp_term_taxonomy      |
| wp_termmeta           |
| wp_terms              |
| wp_usermeta           |
| wp_users              |
+-----------------------+
12 rows in set (0.00 sec)
```
## 5. Установка WordPress
Для решения задачи выбран образ LEMP, php7.2-fpm
1. Роль [wordpress](https://github.com/nikolaybelorusov/devops-netology/tree/main/sysadm-homeworks/diplom/ansible/roles/wordpress)
2. Установлен и настроен Wordpress ![img_8.png](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/diplom/screenshots/www.JPG)

## 6. Установка Gitlab CE и Gitlab Runner
Для решения задачи использованы Gitlab-ce(docker-версия) и Gitlab-runner (shell-версия)
1. Роли [gitlab](https://github.com/nikolaybelorusov/devops-netology/tree/main/sysadm-homeworks/diplom/ansible/roles/gitlab) и [runner](https://github.com/nikolaybelorusov/devops-netology/tree/main/sysadm-homeworks/diplom/ansible/roles/runner)
2. Настроен runner
![img_2.png](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/diplom/screenshots/gitlab/runner_start.JPG)
![img_1.png](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/diplom/screenshots/gitlab/runner.JPG)
3. Создан проект wp, настроен CI/CD.
![img.png](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/diplom/screenshots/gitlab/project.JPG)
4. Commit и результат
![img_3.png](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/diplom/screenshots/gitlab/commit.JPG)
![img_4.png](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/diplom/screenshots/gitlab/result.JPG)
## 7. Установка Prometheus, Alert Manager, Node Exporter и Grafana
1. Роли [node-exporter](https://github.com/nikolaybelorusov/devops-netology/tree/main/sysadm-homeworks/diplom/ansible/roles/node-exporter), [prometheus](https://github.com/nikolaybelorusov/devops-netology/tree/main/sysadm-homeworks/diplom/ansible/roles/prometheus), [grafana](https://github.com/nikolaybelorusov/devops-netology/tree/main/sysadm-homeworks/diplom/ansible/roles/grafana/tasks), [alertmanager](https://github.com/nikolaybelorusov/devops-netology/tree/main/sysadm-homeworks/diplom/ansible/roles/alertmanager)
2. Grafana ![img_5.png](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/diplom/screenshots/grafana.JPG)
3. Alertmanager![img_6.png](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/diplom/screenshots/alertmanager.JPG)
4. Prometheus![img_7.png](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/diplom/screenshots/prometheus.JPG)
Для примера остановлен Runner