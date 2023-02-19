#!/bin/bash

if [ $# != 2 ]
then
	echo Два параметра. echo Формат использовани
	echo $0 IP_MASTER IP_SLAVE
	echo $0 192.168.1.1 192.168.1.2
	exit 1
else
	#==Set IP VM. 1st Arg = IP_MASTER, 2st Arg = IP_SLAVE
	sed "s/IP_MASTER/$1/" ./hosts_b.txt > 1
	sed "s/IP_SLAVE/$2/" ./1 > hosts.txt

        #==CP Files for Job HelloPY+Minikube+Grafana
        scp ~/ansible/configH.xml srbektimirov@$1:~/configH.xml
        scp ~/ansible/nextBuildNumberH srbektimirov@$1:~/nextBuildNumberH
        scp ~/ansible/legacyIdsH srbektimirov@$1:~/legacyIdsH
        scp ~/ansible/permalinksH srbektimirov@$1:~/permalinksH

        #==CP Files for Job Proxy
        scp ~/ansible/configP.xml srbektimirov@$1:~/configP.xml
        scp ~/ansible/nextBuildNumberP srbektimirov@$1:~/nextBuildNumberP
        scp ~/ansible/legacyIdsP srbektimirov@$1:~/legacyIdsP
        scp ~/ansible/permalinksP srbektimirov@$1:~/permalinksP

	#==Play Master
	ansible-playbook set_master.yaml
	#==Copy Jenkins Pub_Key
	scp srbektimirov@$1:~/1 ~/ansible/1
        echo '=#=#=#=#=Jenkins Public Key=#=#=#=#='
        cat 1
	scp ~/ansible/1 srbektimirov@$2:~/1
	scp srbektimirov@$1:~/2 ~/ansible/1
	echo '=#=#=#=#=Jenkins Privet Key=#=#=#=#='
	cat 1
	scp srbektimirov@$1:~/3 ~/ansible/1
	echo '=#=#=#=#=1st Password for Jenkins=#=#=#=#='
	cat 1
        echo "go to Jenkins ==> http://$1:8080"
	#==Play Slave
	ansible-playbook set_slave.yaml
fi
