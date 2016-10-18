variable "name"               { }
variable "project_id"         { }
variable "credentials"        { }
variable "atlas_username"     { }
variable "atlas_environment"  { }
variable "atlas_token"        { }
variable "region"             { }
variable "network"            { }
variable "zones"              { }
variable "consul_log_level"   { }
variable "nomad_log_level"    { }
variable "nomad_region"       { }
variable "nomad_datacenters"  { }
variable "nomad_node_classes" { }
variable "nomad_join_name"    { }
variable "datacenter"         { }
variable "ssh_keys"           { }
variable "private_key"        { }

variable "consul_server_image"   { }
variable "consul_server_machine" { }
variable "consul_server_disk"    { }
variable "consul_servers"        { }

variable "nomad_server_image"   { }
variable "nomad_server_machine" { }
variable "nomad_server_disk"    { }
variable "nomad_servers"        { }

module "consul_servers" {
  source = "./consul_server"

  name              = "${var.name}-consul-server"
  project_id        = "${var.project_id}"
  credentials       = "${var.credentials}"
  atlas_username    = "${var.atlas_username}"
  atlas_environment = "${var.atlas_environment}"
  atlas_token       = "${var.atlas_token}"
  region            = "${var.region}"
  network           = "${var.network}"
  zones             = "${var.zones}"
  image             = "${var.consul_server_image}"
  machine_type      = "${var.consul_server_machine}"
  disk_size         = "${var.consul_server_disk}"
  servers           = "${var.consul_servers}"
  consul_log_level  = "${var.consul_log_level}"
  datacenter        = "${var.datacenter}"
  ssh_keys          = "${var.ssh_keys}"
  private_key       = "${var.private_key}"
}

module "nomad_servers" {
  source = "./nomad_server"

  name               = "${var.name}-nomad-server"
  project_id         = "${var.project_id}"
  credentials        = "${var.credentials}"
  atlas_username     = "${var.atlas_username}"
  atlas_environment  = "${var.atlas_environment}"
  atlas_token        = "${var.atlas_token}"
  region             = "${var.region}"
  network            = "${var.network}"
  zones              = "${var.zones}"
  image              = "${var.nomad_server_image}"
  machine_type       = "${var.nomad_server_machine}"
  disk_size          = "${var.nomad_server_disk}"
  servers            = "${var.nomad_servers}"
  consul_log_level   = "${var.consul_log_level}"
  nomad_log_level    = "${var.nomad_log_level}"
  nomad_region       = "${var.nomad_region}"
  nomad_datacenters  = "${var.nomad_datacenters}"
  nomad_node_classes = "${var.nomad_node_classes}"
  nomad_join_name    = "${var.nomad_join_name}"
  datacenter         = "${var.datacenter}"
  ssh_keys           = "${var.ssh_keys}"
  private_key        = "${var.private_key}"
}

output "consul_server_names"         { value = "${module.consul_servers.names}" }
output "consul_server_machine_types" { value = "${module.consul_servers.machine_types}" }
output "consul_server_private_ips"   { value = "${module.consul_servers.private_ips}" }
output "consul_server_public_ips"    { value = "${module.consul_servers.public_ips}" }

output "nomad_server_names"         { value = "${module.nomad_servers.names}" }
output "nomad_server_machine_types" { value = "${module.nomad_servers.machine_types}" }
output "nomad_server_private_ips"   { value = "${module.nomad_servers.private_ips}" }
output "nomad_server_public_ips"    { value = "${module.nomad_servers.public_ips}" }
