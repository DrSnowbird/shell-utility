#!/bin/bash -x

dockerd-rootless-setuptool.sh install -f
docker context use rootless

minikube start --driver=docker --container-runtime=containerd

