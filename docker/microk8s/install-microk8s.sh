#!/bin/bash -x

# ref: https://microk8s.io/?_ga=2.213749268.1486386038.1675612330-421759932.1675612330#install-microk8s

sudo snap install microk8s --classic
sudo usermod -a -G microk8s user1
sudo chown -R user1 ~/.kube

newgrp microk8s
microk8s enable dashboard dns registry istio
microk8s kubectl get all --all-namespaces

microk8s dashboard-proxy &

echo ">>>"
echo ">>> Dashboard will be available at https://127.0.0.1:10443"
echo ">>> copy-and-paste the (very) long token to login (above)"
echo "..."
