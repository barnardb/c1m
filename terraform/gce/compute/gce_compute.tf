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
variable "nomad_node_classes" { }
variable "nomad_join_name"    { }
variable "datacenter"         { }
variable "ssh_keys"           { }
variable "private_key"        { }

variable "nomad_client_image"   { }
variable "nomad_client_machine" { }
variable "nomad_client_disk"    { }
variable "nomad_client_groups"  { }
variable "nomad_clients"        { }

variable "utility_image"   { }
variable "utility_machine" { }
variable "utility_disk"    { }

module "nomad_clients_igm" {
  source = "./nomad_client_igm"

  name               = "${var.name}-nomad-client"
  project_id         = "${var.project_id}"
  credentials        = "${var.credentials}"
  atlas_username     = "${var.atlas_username}"
  atlas_environment  = "${var.atlas_environment}"
  atlas_token        = "${var.atlas_token}"
  region             = "${var.region}"
  network            = "${var.network}"
  zones              = "${var.zones}"
  image              = "${var.nomad_client_image}"
  machine_type       = "${var.nomad_client_machine}"
  disk_size          = "${var.nomad_client_disk}"
  groups             = "${var.nomad_client_groups}"
  clients            = "${var.nomad_clients}"
  consul_log_level   = "${var.consul_log_level}"
  nomad_log_level    = "${var.nomad_log_level}"
  nomad_region       = "${var.nomad_region}"
  nomad_node_classes = "${var.nomad_node_classes}"
  nomad_join_name    = "${var.nomad_join_name}"
  datacenter         = "${var.datacenter}"
  ssh_keys           = "${var.ssh_keys}"
  private_key        = "${var.private_key}"
}

module "utility" {
  source = "./utility"

  name              = "${var.name}-utility"
  project_id        = "${var.project_id}"
  credentials       = "${var.credentials}"
  atlas_username    = "${var.atlas_username}"
  atlas_environment = "${var.atlas_environment}"
  atlas_token       = "${var.atlas_token}"
  region            = "${var.region}"
  network           = "${var.network}"
  zones             = "${var.zones}"
  image             = "${var.utility_image}"
  machine_type      = "${var.utility_machine}"
  disk_size         = "${var.utility_disk}"
  consul_log_level  = "${var.consul_log_level}"
  datacenter        = "${var.datacenter}"
  ssh_keys          = "${var.ssh_keys}"
  private_key       = "${var.private_key}"
}

output "utility_name"         { value = "${module.utility.name}" }
output "utility_machine_type" { value = "${module.utility.machine_type}" }
output "utility_private_ip"   { value = "${module.utility.private_ip}" }
output "utility_public_ip"    { value = "${module.utility.public_ip}" }
