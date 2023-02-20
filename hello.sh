#!/bin/bash
#Get IP agent (use in Prometheus and Grafana)
IP=$(wget -qO- eth0.me)
touch 1
#Build Docker
eval $(minikube docker-env)
docker build -t hellopy .

#Deploying Exporters
sudo mv /home/srbektimirov/node-exporter.service /etc/systemd/system/node-exporter.service
sudo mv /home/srbektimirov/cadvisor.service /etc/systemd/system/cadvisor.service
sudo mv /home/srbektimirov/blackbox-exporter.service /etc/systemd/system/blackbox-exporter.service
sudo systemctl daemon-reload
sudo systemctl start node-exporter cadvisor blackbox-exporter
sudo systemctl enable node-exporter cadvisor blackbox-exporter

#Deploying Alertmanager
sudo mkdir /etc/alertmanager
sudo mv /home/srbektimirov/alertmanager.yml /etc/alertmanager/alertmanager.yml
sudo mv /home/srbektimirov/alertmanager.service /etc/systemd/system/alertmanager.service
sudo systemctl daemon-reload
sudo systemctl start alertmanager
sudo systemctl enable alertmanager

#Deploying Prometheus
sudo useradd -M -u 1101 -s /bin/false prometheus
sudo mkdir -p /etc/prometheus/rule_files # каталог конфигурации
sudo mkdir -p /data/prometheus # каталог данных
sudo chown -R prometheus /etc/prometheus /data/prometheus
sudo sed "s/IP/${IP}/g" ./prometheus.yml > 1
sudo cp 1 /etc/prometheus/prometheus.yml
sudo mv /home/srbektimirov/mainp.yml /etc/prometheus/rule_files/main.yml
sudo mv /home/srbektimirov/prometheus.service /etc/systemd/system/prometheus.service
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

#Deploying Grafana
sudo useradd -M -u 1102 -s /bin/false grafana
sudo mkdir -p /etc/grafana/provisioning/datasources # каталог декларативного описания источников данных
sudo mkdir /etc/grafana/provisioning/dashboards # каталог декларативного описания дашбордов
sudo mkdir -p /data/grafana/dashboards # каталог данных
sudo chown -R grafana /etc/grafana/ /data/grafana
sudo sed "s/IP/${IP}/g" ./maing.yml > 1
sudo mv 1 /etc/grafana/provisioning/datasources/main.yml
sudo mv /home/srbektimirov/maing2.yml /etc/grafana/provisioning/dashboards/main.yml
cd ~/ && git clone https://github.com/rfmoz/grafana-dashboards
sudo cp grafana-dashboards/prometheus/node-exporter-full.json /data/grafana/dashboards/
sudo mv /home/srbektimirov/grafana.service /etc/systemd/system/grafana.service
sudo systemctl daemon-reload
sudo systemctl start grafana
sudo systemctl enable grafana

#Deploying webapp
kubectl apply -f secret.yaml
kubectl apply -f db-deployment.yaml
kubectl apply -f web-deployment.yaml
