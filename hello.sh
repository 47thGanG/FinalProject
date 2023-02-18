#!/bin/bash
#minikube start
eval $(minikube docker-env)
docker build -t hellopy .

mv /home/srbektimirov/node-exporter.service /etc/systemd/system/node-exporter.service
mv /home/srbektimirov/cadvisor.service /etc/systemd/system/cadvisor.service
mv /home/srbektimirov/blackbox-exporter.service /etc/systemd/system/blackbox-exporter.service

sudo systemctl daemon-reload
sudo systemctl start node-exporter cadvisor blackbox-exporter
sudo systemctl status node-exporter cadvisor blackbox-exporter
sudo systemctl enable node-exporter cadvisor blackbox-exporter

kubectl apply -f secret.yaml
kubectl apply -f db-deployment.yaml
kubectl apply -f web-deployment.yaml

###
#kubectl expose service my-prom-prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-np
#kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-np

###по яндексу
#helm install trickster tricksterproxy/trickster --namespace default -f trickster.yaml
#kubectl apply -f grafana.yaml

#MKIP=$(minikube ip)
#CURL=$(curl $MKIP:30000)
#echo -e "\ncurl $MKIP:30000\n $CURL"
#MYIP=$(hostname -I)
#MYIPgoto=($(echo $MYIP | tr " " "\n"))
#echo -e "\ngo to ==> http://${MYIPgoto[0]}:8080/api/v1/namespaces/default/services/http:web:/proxy/\n\nor use this IP:"
#for i in "${MYIPgoto[@]}"
#do
#    echo -e "$i"
#done
#echo -e ""
#kubectl proxy --address='0.0.0.0' --port=8080 --accept-hosts='.*'
