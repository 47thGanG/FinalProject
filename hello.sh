#!/bin/bash
minikube start
eval $(minikube docker-env)
docker build -t hellopy .
kubectl apply -f secret.yaml
kubectl apply -f db-deployment.yaml
kubectl apply -f web-deployment.yaml

MKIP=$(minikube ip)
CURL=$(curl $MKIP:30000)
echo -e "\ncurl $MKIP:30000\n $CURL"
MYIP=$(hostname -I)
MYIPgoto=($(echo $MYIP | tr " " "\n"))
echo -e "\ngo to ==> http://${MYIPgoto[0]}:8080/api/v1/namespaces/default/services/http:web:/proxy/\n\nor use this IP:"
for i in "${MYIPgoto[@]}"
do
    echo -e "$i"
done
echo -e ""
kubectl proxy --address='0.0.0.0' --port=8080 --accept-hosts='.*'
