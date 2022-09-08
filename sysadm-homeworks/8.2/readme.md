# Домашнее задание к занятию "08.02 Работа с Playbook"
```commandline

---
- name: Install Java   #Название play
  hosts: all   #Для всех групп хостов
  remote_user: root   # пользователь, под которым будем подключаться к удаленным серверам
  tasks:   # Задачи play
    - name: Install update   # Название задачи
       raw: apt -y update && apt-get -y install python3-pip   # Обновление и установка python3-pip
    - name: Set facts for Java 11 vars
      set_fact:   # Задает переменную во время выполнения playbook
        java_home: "/opt/jdk/{{ java_jdk_version }}"# Переменная java_home принимает значение путь + версия вакета из group_vars
      tags: java   # Тег для возможности выполнять задачи выборочно
    - name: Upload .tar.gz file containing binaries from local storage
      copy:   # Копирование из src в dst
        src: "{{ java_oracle_jdk_package }}"   # Значение переменной из group_vars
        dest: "/tmp/jdk-{{ java_jdk_version }}.tar.gz"
      register: download_java_binaries   #Задает переменную, куда будет сохранен вывод задачи
      until: download_java_binaries is succeeded   #Выполняет 3 попытки копирования в dest
      tags: java
    - name: Ensure installation dir exists
      file:   # Модуль создания файла или директории
        state: directory   # Создание директории
        path: "{{ java_home }}"   # Имя директории
      tags: java
    - name: Extract java in the installation directory
      unarchive:   # Модуль распаковки
        copy: false   # Использование локального архива на целевом сервере
        src: "/tmp/jdk-{{ java_jdk_version }}.tar.gz"   # Источник
        dest: "{{ java_home }}"   # Назначение
        extra_opts: [--strip-components=1]   # Параметр распаковки для исключения папки первого уровня архива 
        creates: "{{ java_home }}/bin/java"   # Если файл уже существует, то выполняться не будет
      tags:
        - java
    - name: Export environment variables
      template:   # Модуль копирования из файла src в файл dest
        src: jdk.sh.j2
        dest: /etc/profile.d/jdk.sh
      tags: java
- name: Install Elasticsearch
  hosts: elasticsearch   # Для хостов группы elasticsearch
  tasks:
    - name: Upload tar.gz Elasticsearch from remote URL
      get_url:   # Модуль позволяющий скачать файл по HTTP, HTTPS или FTP из src в dest
        url: "https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-{{ elastic_version }}-linux-x86_64.tar.gz"
        dest: "/tmp/elasticsearch-{{ elastic_version }}-linux-x86_64.tar.gz"
        mode: 0755   # Назначение прав на скачанный файл
        timeout: 60   # Таймаут для URL запроса
        force: true   # Загружать каждый раз, если изменилось содержание
        validate_certs: false   # Не проверяет SSl сертификаты
      register: get_elastic   #Задает переменную, куда будет сохранен вывод задачи
      until: get_elastic is succeeded   #Выполняет 3 попытки копирования в dest
      tags: elastic
    - name: Create directrory for Elasticsearch
      file: 
        state: directory
        path: "{{ elastic_home }}"   # Создание новой дирктории
      tags: elastic
    - name: Extract Elasticsearch in the installation directory
      become: true   # Выполение команд с правами суперпользователя 
      unarchive:   # Модуль распаковки из src в dest если не существует файла
        copy: false
        src: "/tmp/elasticsearch-{{ elastic_version }}-linux-x86_64.tar.gz"
        dest: "{{ elastic_home }}"
        extra_opts: [--strip-components=1]
        creates: "{{ elastic_home }}/bin/elasticsearch"
      tags:
        - elastic
    - name: Set environment Elastic
      become: true
      template:   # Модуль копирования из файла src в файл dest
        src: templates/elk.sh.j2
        dest: /etc/profile.d/elk.sh
      tags: elastic
- name: Install kibana
  hosts: kibana   # Для хостов группы kibana
  tasks:
     - name: Upload tar.gz kibana from local
       copy:   # Копирование файла из src в dest
         src: "{{ kibana_package }}"
         dest: "/tmp/kibana-{{ kibana_version }}.tar.gz"
       register: download_kibana_binaries
       until: download_kibana_binaries is succeeded
       tags: kibana
     - name: Installation dir exist
       file:   #Создание директории
         state: directory
         path: "{{ kibana_home }}"
       tags: kibana
     - name: Extract
       unarchive:   # Распаковка архива
         copy: false
         src: "/tmp/kibana-{{ kibana_version }}.tar.gz"
         dest: "{{ kibana_home }}"
         creates: "{{ kibana_home }}/bin/kibana"
       tags: kibana
```
https://github.com/nikolaybelorusov/devops-netology/blob/46222eda6645db6004fe9c04cc7174518fa9a0bf/sysadm-homeworks/8.2/site.yml