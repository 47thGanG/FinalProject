***# FinalProject***
1. Создаём две ВМ
2. Вставляем ip наших ВМ в hosts.txt в директории Ansible:
```
nano /Users/MacbookSergeyB/ansible/hosts.txt
```
3. Запускаем 3 плэйбука:
```
ansible-playbook installJenkins.yaml
ansible-playbook installMinikube.yaml
ansible-playbook startMinikube.yaml
```
4. Идём в ВМ Master. Переходим в пользователя jenkins. В его домашней директории создаём ключ, публичную часть которого перенесём в authorized_keys на ВМ slave, а приватную часть - в jenkins Credentials для пользователя srbektimirov. 
```
ssh srbektimirov@158.160.53.166
sudo su
su - jenkins
ssh-keygen
cat /var/lib/jenkins/.ssh/id_rsa
cat /var/lib/jenkins/.ssh/id_rsa.pub
```
>Спасибо: https://www.youtube.com/watch?v=ee1XcQxKfRk
5. Добавляем Agent в jenkins. Не забываем установить плагин 
6. Создадим Freestyle Project, где указываем, что это

6.1 GitHub project
> Project url: https://github.com/47thGanG/FinalProject.git

6.2 Ограничим лейблы сборщиков, которые могут исполнять данную задачу
> slave

6.3 Управление исходным кодом: Git
> Repository URL: https://github.com/47thGanG/FinalProject.git/

6.4 Branches to build:
> */main

6.5 Добавим шаги сборки (Выполнить команду shell):
```
echo '---------------Build Started---------------'
mv /home/srbektimirov/workspace/Hello.Py\ +\ Minikube/* /home/srbektimirov
cd /home/srbektimirov
chmod +x hello.sh
./hello.sh
echo '---------------Build Finished---------------'
```
```
echo '---------------Test Started---------------'
echo 'Your tests could be here'
echo '---------------Test Finished---------------'
```
6.6 Добавим послесборочную операцию: Cобрать другой проект
> ProxyRun; 
> Только когда сборка стабильна

7. Создадим второй Freestyle Project
> ProxyRun

7.1 Снова ограничим лейблы сборщиков, которые могут исполнять данную задачу
> slave

7.2 Добавим триггеры сборки
> Запустить по окончанию сборки других проектов: Hello.Py + Minikube; 

7.3 Добавим шаг сборки (Выполнить команду shell):
```
IP=$(wget -qO- eth0.me)
echo -e "\ngo to ==> http://${IP}:8080/api/v1/namespaces/default/services/http:web:/proxy/\n\nor use this IP:"
echo -e ""
kubectl proxy --address='0.0.0.0' --port=8080 --accept-hosts='.*'
```
8. Можем подключаться по адресу, указаному в консольном выводе **ProxyRun**.
