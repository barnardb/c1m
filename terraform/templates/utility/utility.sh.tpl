#!/bin/bash
set -e

logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT utility.sh: $1"
  echo "$DT utility.sh: $1" | sudo tee -a /var/log/user_data.log > /dev/null
}

logger "Begin script"

${cloud_specific}

logger "Setting private key"
echo "${private_key}" | sudo tee /home/ubuntu/c1m/site.pem > /dev/null
sudo chmod 400 /home/ubuntu/c1m/site.pem

NODE_NAME="$(hostname)"
logger "Node name: $NODE_NAME"

METADATA_LOCAL_IP=`curl ${local_ip_url}`
logger "Local IP: $METADATA_LOCAL_IP"

logger "Configuring Consul"
CONSUL_DEFAULT_CONFIG=/etc/consul.d/default.json
CONSUL_DATA_DIR=${data_dir}/consul/data

sudo mkdir -p $CONSUL_DATA_DIR
sudo chmod 0755 $CONSUL_DATA_DIR

sudo sed -i -- "s/{{ data_dir }}/$${CONSUL_DATA_DIR//\//\\\/}/g" $CONSUL_DEFAULT_CONFIG
sudo sed -i -- "s/{{ datacenter }}/${datacenter}/g" $CONSUL_DEFAULT_CONFIG
sudo sed -i -- "s/{{ node_name }}/$NODE_NAME/g" $CONSUL_DEFAULT_CONFIG
sudo sed -i -- "s/{{ local_ip }}/$METADATA_LOCAL_IP/g" $CONSUL_DEFAULT_CONFIG
sudo sed -i -- "s/{{ log_level }}/${consul_log_level}/g" $CONSUL_DEFAULT_CONFIG

logger "Configuring Consul Utility"
CONSUL_UTILITY_CONFIG=/etc/consul.d/utility.json
sudo mv /etc/consul-optional.d/utility.json $CONSUL_UTILITY_CONFIG

sudo sed -i -- "s/\"{{ tags }}\"/\"${provider}\", \"${region}\", \"${zone}\", \"${machine_type}\"/g" $CONSUL_UTILITY_CONFIG

logger "Starting Consul"
echo $(date '+%s') | sudo tee -a /etc/consul.d/configured > /dev/null
sudo service consul start || sudo service consul restart

logger "Setting NOMAD_ADDR"
echo "NOMAD_ADDR=http://nomad-server.service.consul:4646" | sudo tee -a /etc/environment

logger "Done"
