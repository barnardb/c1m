#!/bin/bash
set -e
set -x

logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT consul_server.sh: $1"
  echo "$DT consul_server.sh: $1" | sudo tee -a /var/log/user_data.log > /dev/null
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

logger "Configuring Consul server"
CONSUL_SERVER_CONFIG=/etc/consul.d/consul_server.json
sudo mv /etc/consul-optional.d/consul_server.json $CONSUL_SERVER_CONFIG

sudo sed -i -- "s/{{ bootstrap_expect }}/${bootstrap_expect}/g" $CONSUL_SERVER_CONFIG
sudo sed -i -- "s/\"{{ tags }}\"/\"${provider}\", \"${region}\", \"${zone}\", \"${machine_type}\"/g" $CONSUL_SERVER_CONFIG

echo $(date '+%s') | sudo tee -a /etc/consul.d/configured > /dev/null
sudo service consul start || sudo service consul restart

logger "Done"
