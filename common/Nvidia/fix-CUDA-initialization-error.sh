#!/bin/bash -x

## source: 

## Errors:
##   print(torch.cuda.is_available())
## >>
## And, get the following error:
## UserWarning: CUDA initialization: CUDA unknown error - this may be due to an incorrectly set up environment, e.g. changing env variable CUDA_VISIBLE_DEVICES after program start. Setting the available devices to be zero. (Triggered internally at  /pytorch/c10/cuda/CUDAFunctions.cpp:100.)
##  return torch._C._cuda_getDeviceCount() > 0

## Use the following two commands - it will fix/reset the error situation!
##

sudo rmmod nvidia_uvm
sudo modprobe nvidia_uvm

echo -e ">>> ... "
echo -e ">>> You can try again with querying CUDA information"
echo -e ">>> python3 -c 'import torch ; print(torch.cuda.is_available())' "
echo -e ">>> ..."


