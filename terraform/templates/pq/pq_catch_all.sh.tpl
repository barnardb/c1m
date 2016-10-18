#!/bin/bash
set -e

logger() {
  DT=$(date '+%Y/%m/%d %H:%M:%S')
  echo "$DT pq_catch_all.sh: $1" | sudo tee -a /var/log/user_data.log > /dev/null
}

logger "Begin script"

CONSUL_ADDR=http://127.0.0.1:8500

servers() {
  PASSING=$(curl -s "$CONSUL_ADDR/v1/health/service/${consul_join_name}")

  # Check if valid json is returned, otherwise jq command fails
  if [[ "$PASSING" == [{* ]]; then
    echo $(echo $PASSING | jq -r '.[].Node.Address' | tr '\n' ' ')
  fi
}

logger "Getting Consul servers"
CONSUL_SERVERS=$(servers)
logger "Initial Consul servers: $CONSUL_SERVERS"
CONSUL_SERVER_LEN=$(echo $CONSUL_SERVERS | wc -w)
logger "Initial Consul server length: $CONSUL_SERVER_LEN"
SLEEPTIME=1

while [ $CONSUL_SERVER_LEN -lt 2 ]
do
  if [ $SLEEPTIME -gt 15 ]; then
    logger "ERROR: CONSUL SETUP NOT COMPLETE! Manual intervention required."
    exit 2
  else
    logger "Waiting for optimum quorum size, currently: $CONSUL_SERVER_LEN, waiting $SLEEPTIME seconds"
    CONSUL_SERVERS=$(servers)
    logger "Consul servers: $CONSUL_SERVERS"
    CONSUL_SERVER_LEN=$(echo $CONSUL_SERVERS | wc -w)
    logger "Consul server length: $CONSUL_SERVER_LEN"
    sleep $SLEEPTIME
    SLEEPTIME=$((SLEEPTIME + 1))
  fi
done

logger "Create prepared query"
logger "$(
  curl \
    -H "Content-Type: application/json" \
    -LX POST \
    -d \
'{
  "Name": "",
  "Template": {
    "Type": "name_prefix_match",
    "Regexp": ""
  },
  "Service": {
    "Service": "$${name.full}",
    "Failover": {
      "NearestN": 3
    },
    "OnlyPassing": true,
    "Tags": [${tags}]
  },
  "DNS": {
    "TTL": "10s"
  }
}' $CONSUL_ADDR/v1/query
)"

logger "Done"
