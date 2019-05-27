#!/bin/bash -x

# ------------------------------------ 
# maintainer: DrSnowbird@openkbs.org
# license: Apache License Version 2.0
# ------------------------------------ 

## -- change username and password and clustername according to yours --

#ambari_username=<ChangeMe>
ambari_username=admin

#ambari_password=<ChangeMe>
ambari_password=admin

#ambari_host=<ChangeMe>
ambari_host=127.0.0.1

ambari_port=8080

# Not needed
# clusterName=<ChangeMe>

ambari_component_list=./ambari_component_list.json
ambari_service_list=./ambari_service_list.json
cat /dev/null > ${ambari_component_list}
cat /dev/null > ${ambari_service_list}

echo "1.) Find out Cluster Name:"
curl -u ${ambari_username}:${ambari_password} -H "X-Requested-By: ambari" -X GET http://${ambari_host}:${ambari_port}/api/v1/clusters
clusterName=`curl -u ${ambari_username}:${ambari_password} -H 'X-Requested-By: ambari' -X GET http://${ambari_host}:8080/api/v1/clusters| jq '.items[0].Clusters.cluster_name' | tr -d '"' `

echo "2.) Find out Cluster Components List and status:"
#curl -u ${ambari_username}:${ambari_password} -H "X-Requested-By: ambari" -X GET http://${ambari_host}:${ambari_port}/api/v1/clusters/${clusterName}/components/ -o ${ambari_component_list}
componentList=`curl -u ${ambari_username}:${ambari_password} -H "X-Requested-By: ambari" -X GET http://${ambari_host}:${ambari_port}/api/v1/clusters/${clusterName}/components/ | jq '.items[].ServiceComponentInfo.component_name'  | tr -d '"' `

echo "2-B.) Find out Component Status List:"
for componentName in $componentList; do
    curl -u ${ambari_username}:${ambari_password} -H "X-Requested-By: ambari" -X GET http://${ambari_host}:${ambari_port}/api/v1/clusters/${clusterName}/components/${componentName}?fields=ServiceComponentInfo/state | tee -a ${ambari_component_list}
done

echo "3.) Find out Cluster Services List and status:"
#curl -u ${ambari_username}:${ambari_password} -H "X-Requested-By: ambari" -X GET http://${ambari_host}:${ambari_port}/api/v1/clusters/${clusterName}/services/ -o ${ambari_service_list}
serviceList=`curl -u ${ambari_username}:${ambari_password} -H "X-Requested-By: ambari" -X GET http://${ambari_host}:${ambari_port}/api/v1/clusters/${clusterName}/services/ | jq '.items[].ServiceInfo.service_name'  | tr -d '"' `

echo "3-B.) Find out Service Status List:"
for serviceName in $serviceList; do
    curl -u ${ambari_username}:${ambari_password} -H "X-Requested-By: ambari" -X GET http://${ambari_host}:${ambari_port}/api/v1/clusters/${clusterName}/services/${serviceName}?fields=ServiceInfo/state | tee -a ${ambari_service_list}
done

