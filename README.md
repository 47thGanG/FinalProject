***# FinalProject***
0. Необходимо: ssh ключ на host-машине, установленный ansible, 2 ВМ и SSH доступ к ним.
1. Создаём две ВМ: Первая будет выступать в роли мастера (20% 2 vCPU, 2 Gb RAM, 30 Gb), вторая - агента (50% 4 vCPU, 4 Gb RAM, 50 Gb). 
2. Идём в директорию ansible, забираем все файлы себе. Идём в свою папку ansible и запускаем скрипт ansible.sh с двумя аргументами: 1 - IP Мастера, 2 - IP агента.
```
cd ~/ansible
./ansible.sh IP_MASTER IP_AGENT
```
3. Во время действия скрипта, при первых подключениях к ВМ потребуется дважды ввести yes (во время запуска playbook-ов с настройкой Мастера и Агента)
4. Переходим в Jenkins по предоставленной скриптом ссылке. Не забываем установить плагин, после установки которого произойдёт перезагрузка Jenkins и отобразятся Job'ы. Добавляем Агента в jenkins.
5. После того, как убедимся, что Agent добавлен, запускаем HelloPY+Minikube+Grafana. Данный Job заберёт все необходимые файлы из github, перенесёт их на сборщик с лэйблом slave, и запустит скрипт.
6. По окончании HelloPY+Minikube+Grafana, автоматически запустится Proxy.
7. Можем подключаться по адресам, указаным в консольном выводе Job'ы **Proxy**.

Используемые источники:
>Jenkins, добавление Agent: https://www.youtube.com/watch?v=ee1XcQxKfRk;

>Adv-it, Jenkins, Ansible: https://www.youtube.com/@ADV-IT/playlists;

>Grafana, prometheus, node-exporter: https://habr.com/ru/post/709204/

=============================Что улучшить?=============================

1. Нет реализации масштабирования и распределённости;
2. Не удалось полностью автоматизировать Jenkins (добавление Агентов, credentials);
3. Нет проверок об уже выполненных вещах;
4. PG не в minikube, dashboard никак не кастомизирован;
5. Запуск при изменених только через кнопку (можно добавить триггер по коммиту в мастер-ветку гитхаба).
