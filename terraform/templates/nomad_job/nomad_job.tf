variable "region"      { default = "global" }
variable "datacenters" { }

variable "classlogger_image" { default = "hashicorp/nomad-c1m:0.1" }

variable "redis_count" { default = "1" }
variable "redis_image" { default = "hashidemo/redis:latest" }
variable "redis_tags"  { default = "\"global\"" }

variable "server_count"           { default = "1" }
variable "server_artifact_source" { }
variable "server_command"         { }
variable "server_tags"            { default = "\"global\"" }

variable "client_count"           { default = "1" }
variable "client_artifact_source" { }
variable "client_command"         { }
variable "client_request_address" { }
variable "client_tags"            { default = "\"global\"" }

variable "nginx_count"  { default = "1" }
variable "nginx_image"  { default = "hashidemo/nginx:latest" }
variable "nginx_tags"   { default = "\"global\"" }
variable "nodejs_count" { default = "1" }
variable "nodejs_image" { default = "hashidemo/nodejs:latest" }
variable "nodejs_tags"  { default = "\"global\"" }

module "classlogger_1" {
  source = "./classlogger"

  region      = "${var.region}"
  datacenters = "${var.datacenters}"
  count       = "1"
  image       = "${var.classlogger_image}"
}

module "classlogger_20" {
  source = "./classlogger"

  region      = "${var.region}"
  datacenters = "${var.datacenters}"
  count       = "20"
  image       = "${var.classlogger_image}"
}

module "classlogger_200" {
  source = "./classlogger"

  region      = "${var.region}"
  datacenters = "${var.datacenters}"
  count       = "200"
  image       = "${var.classlogger_image}"
}

module "classlogger_2000" {
  source = "./classlogger"

  region      = "${var.region}"
  datacenters = "${var.datacenters}"
  count       = "2000"
  image       = "${var.classlogger_image}"
}

module "redis" {
  source = "./redis"

  region      = "${var.region}"
  datacenters = "\"gce-us-central1\""
  count       = "${var.redis_count}"
  image       = "${var.redis_image}"
  tags        = "${var.redis_tags}"
}

module "server" {
  source = "./server"

  region          = "${var.region}"
  datacenters     = "${var.datacenters}"
  count           = "${var.server_count}"
  artifact_source = "${var.server_artifact_source}"
  command         = "${var.server_command}"
  tags            = "${var.server_tags}"
}

module "server_gce_us_central1" {
  source = "./server"

  region          = "${var.region}"
  datacenters     = "\"gce-us-central1\""
  count           = "${var.server_count}"
  artifact_source = "${var.server_artifact_source}"
  command         = "${var.server_command}"
  tags            = "${var.server_tags}"
}

module "server_gce_us_east1" {
  source = "./server"

  region          = "${var.region}"
  datacenters     = "\"gce-us-east1\""
  count           = "${var.server_count}"
  artifact_source = "${var.server_artifact_source}"
  command         = "${var.server_command}"
  tags            = "${var.server_tags}"
}

module "server_gce_europe_west1" {
  source = "./server"

  region          = "${var.region}"
  datacenters     = "\"gce-europe-west1\""
  count           = "${var.server_count}"
  artifact_source = "${var.server_artifact_source}"
  command         = "${var.server_command}"
  tags            = "${var.server_tags}"
}

module "server_gce_asia_east1" {
  source = "./server"

  region          = "${var.region}"
  datacenters     = "\"gce-asia-east1\""
  count           = "${var.server_count}"
  artifact_source = "${var.server_artifact_source}"
  command         = "${var.server_command}"
  tags            = "${var.server_tags}"
}

module "client" {
  source = "./client"

  region          = "${var.region}"
  datacenters     = "${var.datacenters}"
  count           = "${var.client_count}"
  artifact_source = "${var.client_artifact_source}"
  command         = "${var.client_command}"
  request_address = "${var.client_request_address}"
  tags            = "${var.client_tags}"
}

module "client_gce_us_central1" {
  source = "./client"

  region          = "${var.region}"
  datacenters     = "\"gce-us-central1\""
  count           = "${var.client_count}"
  artifact_source = "${var.client_artifact_source}"
  command         = "${var.client_command}"
  request_address = "${var.client_request_address}"
  tags            = "${var.client_tags}"
}

module "client_gce_us_east1" {
  source = "./client"

  region          = "${var.region}"
  datacenters     = "\"gce-us-east1\""
  count           = "${var.client_count}"
  artifact_source = "${var.client_artifact_source}"
  command         = "${var.client_command}"
  request_address = "${var.client_request_address}"
  tags            = "${var.client_tags}"
}

module "client_gce_europe_west1" {
  source = "./client"

  region          = "${var.region}"
  datacenters     = "\"gce-europe-west1\""
  count           = "${var.client_count}"
  artifact_source = "${var.client_artifact_source}"
  command         = "${var.client_command}"
  request_address = "${var.client_request_address}"
  tags            = "${var.client_tags}"
}

module "client_gce_asia_east1" {
  source = "./client"

  region          = "${var.region}"
  datacenters     = "\"gce-asia-east1\""
  count           = "${var.client_count}"
  artifact_source = "${var.client_artifact_source}"
  command         = "${var.client_command}"
  request_address = "${var.client_request_address}"
  tags            = "${var.client_tags}"
}

module "web" {
  source = "./web"

  region       = "${var.region}"
  datacenters  = "${var.datacenters}"
  nginx_count  = "${var.nginx_count}"
  nginx_image  = "${var.nginx_image}"
  nginx_tags   = "${var.nginx_tags}"
  nodejs_count = "${var.nodejs_image}"
  nodejs_image = "${var.nodejs_image}"
  nodejs_tags  = "${var.nodejs_tags}"
}

output "script" {
  value = <<CMD
echo "Creating job files"

echo "Creating C1M classlogger_1 job files"
cat > /opt/nomad/jobs/classlogger_1_docker.nomad <<EOF
${module.classlogger_1.docker_job}
EOF

cat > /opt/nomad/jobs/classlogger_1_consul_docker.nomad <<EOF
${module.classlogger_1.consul_docker_job}
EOF

cat > /opt/nomad/jobs/classlogger_1_raw_exec.nomad <<EOF
${module.classlogger_1.raw_exec_job}
EOF

cat > /opt/nomad/jobs/classlogger_1_consul_raw_exec.nomad <<EOF
${module.classlogger_1.consul_raw_exec_job}
EOF

echo "Creating C1M classlogger_20 job files"
cat > /opt/nomad/jobs/classlogger_20_docker.nomad <<EOF
${module.classlogger_20.docker_job}
EOF

cat > /opt/nomad/jobs/classlogger_20_consul_docker.nomad <<EOF
${module.classlogger_20.consul_docker_job}
EOF

cat > /opt/nomad/jobs/classlogger_20_raw_exec.nomad <<EOF
${module.classlogger_20.raw_exec_job}
EOF

cat > /opt/nomad/jobs/classlogger_20_consul_raw_exec.nomad <<EOF
${module.classlogger_20.consul_raw_exec_job}
EOF

echo "Creating C1M classlogger_200 job files"
cat > /opt/nomad/jobs/classlogger_200_docker.nomad <<EOF
${module.classlogger_200.docker_job}
EOF

cat > /opt/nomad/jobs/classlogger_200_consul_docker.nomad <<EOF
${module.classlogger_200.consul_docker_job}
EOF

cat > /opt/nomad/jobs/classlogger_200_raw_exec.nomad <<EOF
${module.classlogger_200.raw_exec_job}
EOF

cat > /opt/nomad/jobs/classlogger_200_consul_raw_exec.nomad <<EOF
${module.classlogger_200.consul_raw_exec_job}
EOF

echo "Creating C1M classlogger_2000 job files"
cat > /opt/nomad/jobs/classlogger_2000_docker.nomad <<EOF
${module.classlogger_2000.docker_job}
EOF

cat > /opt/nomad/jobs/classlogger_2000_consul_docker.nomad <<EOF
${module.classlogger_2000.consul_docker_job}
EOF

cat > /opt/nomad/jobs/classlogger_2000_raw_exec.nomad <<EOF
${module.classlogger_2000.raw_exec_job}
EOF

cat > /opt/nomad/jobs/classlogger_2000_consul_raw_exec.nomad <<EOF
${module.classlogger_2000.consul_raw_exec_job}
EOF

echo "Creating redis job file"
cat > /opt/nomad/jobs/redis.nomad <<EOF
${module.redis.job}
EOF

echo "Creating server job file"
cat > /opt/nomad/jobs/server.nomad <<EOF
${module.server.job}
EOF

echo "Creating server us-central1 job file"
cat > /opt/nomad/jobs/server_gce_us_central1.nomad <<EOF
${module.server_gce_us_central1.job}
EOF

echo "Creating server us-east1 job file"
cat > /opt/nomad/jobs/server_gce_us_east1.nomad <<EOF
${module.server_gce_us_east1.job}
EOF

echo "Creating server europe-west1 job file"
cat > /opt/nomad/jobs/server_gce_europe_west1.nomad <<EOF
${module.server_gce_europe_west1.job}
EOF

echo "Creating server asia-east1 job file"
cat > /opt/nomad/jobs/server_gce_asia_east1.nomad <<EOF
${module.server_gce_asia_east1.job}
EOF

echo "Creating client job file"
cat > /opt/nomad/jobs/client.nomad <<EOF
${module.client.job}
EOF

echo "Creating client us-central1 job file"
cat > /opt/nomad/jobs/client_gce_us_central1.nomad <<EOF
${module.client_gce_us_central1.job}
EOF

echo "Creating client us-east1 job file"
cat > /opt/nomad/jobs/client_gce_us_east1.nomad <<EOF
${module.client_gce_us_east1.job}
EOF

echo "Creating client europe-west1 job file"
cat > /opt/nomad/jobs/client_gce_europe_west1.nomad <<EOF
${module.client_gce_europe_west1.job}
EOF

echo "Creating client asia-east1 job file"
cat > /opt/nomad/jobs/client_gce_asia_east1.nomad <<EOF
${module.client_gce_asia_east1.job}
EOF

echo "Fetch redis-cli-stats"
# curl -L https://s3.amazonaws.com/hashicorp-nomad-demo/redis-cli-stats/bin/redis-cli-stats > /tmp/redis-cli-stats
curl -L https://s3.amazonaws.com/hashicorp-cameron-public/projects/redis-cli-stats/bin/redis-cli-stats > /tmp/redis-cli-stats

echo "Install redis-cli-stats"
sudo mv /tmp/redis-cli-stats /usr/local/bin/redis-cli-stats
sudo chmod 0755 /usr/local/bin/redis-cli-stats
sudo chown root:root /usr/local/bin/redis-cli-stats

echo "Creating web job files"
cat > /opt/nomad/jobs/web.nomad <<EOF
${module.web.job}
EOF

echo "Finished creating job files"
CMD
}
