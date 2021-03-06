# Курсовая работа по итогам модуля "DevOps и системное администрирование"

## 1. Создайте виртуальную машину Linux.
Для создания новой виртуальной машины использовал установочный образ с оф.сайта Ubuntu 20.04.
Для виртуальной машины сетевой адаптер настроен в режиме мост.
Получение ip-адреса на dhcp-сервере.
```enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:47:f7:8f brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.125/24 brd 192.168.0.255 scope global dynamic enp0s3
       valid_lft 85282sec preferred_lft 85282sec
    inet6 fe80::a00:27ff:fe47:f78f/64 scope link
       valid_lft forever preferred_lft forever```
```

## 2. Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты.
Ufw установлен вместе с ОС. 
Дабавлен в автозагрузку. 
Открыты порты 22 и 443 
![alt text](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/dipl/2.1_UFW.PNG)
Осуществлено подключение по ssh
![alt text](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/dipl/2.2_UFW.PNG)

## 3. Установите hashicorp vault
Установлен vault
![alt text](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/dipl/3_vault.PNG)
Запуск сервера
![alt text](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/dipl/3.1_vault.PNG)

## 4. Cоздайте центр сертификации по инструкции и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).
По инстукции создан центр сертификации
![alt text](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/dipl/4.0_CA.PNG)
Сгенерированы корневой, промежуточный и конечный сертификаты
![alt text](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/dipl/4.1_CA.PNG)
![alt text](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/dipl/4.2_CA.PNG)
![alt text](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/dipl/4.3_CA.PNG)

## 5. Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе.
Установлен корневой сертификат в доверенные

## 6. Установите nginx.
Nginx установлен и добавлен в автозапуск.

## 7. По инструкции настройте nginx на https, используя ранее подготовленный сертификат:
Произведена настройка https
![alt text](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/dipl/7_nginx.PNG)

## 8. Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.
Открыта страница https://test.example.com
![alt text](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/dipl/8_nginx.png)

## 9. Создайте скрипт, который будет генерировать новый сертификат в vault
Создан скрипт генерации нового сертификата
![alt text](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/dipl/9.1_script.PNG)

## 10. Поместите скрипт в crontab, чтобы сертификат обновлялся какого-то числа каждого месяца в удобное для вас время.
Скрипт генерации нового сертификата добавлен в планировщик
![alt text](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/dipl/10.1_crontab.PNG)
![alt text](https://github.com/nikolaybelorusov/devops-netology/blob/main/sysadm-homeworks/dipl/10.2_update_cert.PNG)