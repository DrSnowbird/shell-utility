#!/bin/bash -x

# 0. Conda init as 'bash' shell:
conda init bash

# 1. Create the environment from the environment.yml file:
#    The first line of the yml file sets the new environment's name. 
#    For details see Creating an environment file manually.

conda env create -f environment.yml

# 2. Verify that the new environment was installed correctly:
#     You can also use: 
echo -e "\n.............. Use this command: "
conda info --envs
echo -e "\n.............. or this command: "
conda env list

# 3. Activate the new environment: 
conda_env_name=`cat environment.yml | grep "name:" |cut -d' ' -f2`
echo -e ">>>> conda_env_name: ${conda_env_name} \n"
conda activate ${conda_env_name}

