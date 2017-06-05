#!/bin/bash
set -e

logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT worker.sh: $1"
  echo "$DT worker.sh: $1" | sudo tee -a /var/log/user_data.log > /dev/null
}

logger "Begin script"

${cloud_specific}

logger "Setting private key"
echo "${private_key}" | sudo tee /home/ubuntu/c1m/site.pem > /dev/null
sudo chmod 400 /home/ubuntu/c1m/site.pem

logger "Configure Nomad Client"
NODE_NAME="$(hostname)"
logger "Node name: $NODE_NAME"

METADATA_LOCAL_IP=`curl ${local_ip_url}`
logger "Local IP: $METADATA_LOCAL_IP"

logger "Configuring Consul default"
CONSUL_DEFAULT_CONFIG=/etc/consul.d/default.json
CONSUL_DATA_DIR=${data_dir}/consul/data

sudo mkdir -p $CONSUL_DATA_DIR
sudo chmod 0755 $CONSUL_DATA_DIR

sudo sed -i -- "s/{{ data_dir }}/$${CONSUL_DATA_DIR//\//\\\/}/g" $CONSUL_DEFAULT_CONFIG
sudo sed -i -- "s/{{ local_ip }}/$METADATA_LOCAL_IP/g" $CONSUL_DEFAULT_CONFIG
sudo sed -i -- "s/{{ datacenter }}/${datacenter}/g" $CONSUL_DEFAULT_CONFIG
sudo sed -i -- "s/{{ node_name }}/$NODE_NAME/g" $CONSUL_DEFAULT_CONFIG
sudo sed -i -- "s/{{ log_level }}/${consul_log_level}/g" $CONSUL_DEFAULT_CONFIG

logger "Configuring Consul Nomad client"
CONSUL_NOMAD_CLIENT_CONFIG=/etc/consul.d/nomad_client.json
sudo mv /etc/consul-optional.d/nomad_client.json $CONSUL_NOMAD_CLIENT_CONFIG

sudo sed -i -- "s/\"{{ tags }}\"/\"${provider}\", \"${region}\", \"${zone}\", \"${machine_type}\", \"${node_class}\"/g" $CONSUL_NOMAD_CLIENT_CONFIG

echo $(date '+%s') | sudo tee -a /etc/consul.d/configured > /dev/null
sudo service consul start || sudo service consul restart

logger "Configuring Docker"
DOCKER_DATA_DIR=${data_dir}/docker/data

sudo mkdir -p $DOCKER_DATA_DIR
sudo chmod 0755 $DOCKER_DATA_DIR

sudo sed -i -- "s/service.consul/service.consul -g $${DOCKER_DATA_DIR//\//\\\/}/g" /etc/default/docker

sudo service docker restart

logger "Configuring Nomad default"
NOMAD_DEFAULT_CONFIG=/etc/nomad.d/default.hcl
NOMAD_DATA_DIR=${data_dir}/nomad/data

sudo mkdir -p $NOMAD_DATA_DIR
sudo chmod 0755 $NOMAD_DATA_DIR

sudo sed -i -- "s/{{ data_dir }}/$${NOMAD_DATA_DIR//\//\\\/}/g" $NOMAD_DEFAULT_CONFIG
sudo sed -i -- "s/{{ region }}/${region}/g" $NOMAD_DEFAULT_CONFIG
sudo sed -i -- "s/{{ datacenter }}/${datacenter}/g" $NOMAD_DEFAULT_CONFIG
sudo sed -i -- "s/{{ local_ip }}/$METADATA_LOCAL_IP/g" $NOMAD_DEFAULT_CONFIG
sudo sed -i -- "s/{{ node_id }}/$NODE_NAME/g" $NOMAD_DEFAULT_CONFIG
sudo sed -i -- "s/{{ name }}/$NODE_NAME/g" $NOMAD_DEFAULT_CONFIG
sudo sed -i -- "s/{{ log_level }}/${nomad_log_level}/g" $NOMAD_DEFAULT_CONFIG

logger "Configure Nomad client"

sudo rm -f /etc/nomad.d/server.hcl

NOMAD_CLIENT_CONFIG=/etc/nomad.d/client.hcl

sudo sed -i -- "s/{{ node_id }}/$NODE_NAME/g" $NOMAD_CLIENT_CONFIG
sudo sed -i -- "s/{{ region }}/${region}/g" $NOMAD_CLIENT_CONFIG
sudo sed -i -- "s/{{ machine_type }}/${machine_type}/g" $NOMAD_CLIENT_CONFIG
sudo sed -i -- 's/{{ node_class }}/${node_class}/g' $NOMAD_CLIENT_CONFIG

echo $(date '+%s') | sudo tee -a /etc/nomad.d/configured > /dev/null
sudo rm /etc/init/nomad.override
sudo service nomad start || sudo service nomad restart

logger "Configuring Hadoop"

HADOOP_DATA_DIR=${data_dir}/hadoop/data
sudo mkdir -p $HADOOP_DATA_DIR
sudo chmod 0755 $HADOOP_DATA_DIR

HADOOP_CORE_CONFIG=/opt/hadoop/etc/hadoop/core-site.xml
sudo sed -i -- "s#{{ data_dir }}#$HADOOP_DATA_DIR#g" $HADOOP_CORE_CONFIG

YARN_CONFIG=/opt/hadoop/etc/hadoop/yarn-site.xml
PROCESSORS=$(nproc)
MEMORY_MB=$(sudo dmidecode --type memory | grep "Size.*MB" | awk '{s+=$2} END {print s}')
sudo sed -i -- "s#{{ cpus }}#$PROCESSORS#g" $YARN_CONFIG
sudo sed -i -- "s#{{ memory_mb }}#$MEMORY_MB#g" $YARN_CONFIG

logger "Starting HDFS DataNode"
sudo mkdir -p /etc/hadoop.d
echo $(date '+%s') | sudo tee -a /etc/hadoop.d/configured > /dev/null
sudo rm /etc/init/hdfs-datanode.override
sudo service hdfs-datanode start || sudo service hdfs-datanode restart

logger "Starting YARN NodeManager"
sudo mkdir -p /etc/hadoop.d
echo $(date '+%s') | sudo tee -a /etc/hadoop.d/configured > /dev/null
sudo rm /etc/init/yarn-nodemanager.override
sudo service yarn-nodemanager start || sudo service yarn-nodemanager restart

logger "Load load-test docker image"
docker load < /spark-load-test-image.tar

logger "Nomad server join: ${nomad_join_name}"
sleep 15 # Wait for Nomad service to fully boot
sudo /opt/nomad/nomad_join.sh "${nomad_join_name}"

logger "Done"
