#!/bin/bash -x


nvidia-smi

echo "-------------------- running as Docker to test also: -----------"

sudo -i nvidia-smi -pm 1

sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
