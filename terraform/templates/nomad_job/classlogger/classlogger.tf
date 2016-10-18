variable "region"      { default = "global" }
variable "datacenters" { }
variable "priority"    { default = "50" }
variable "count"       { default = "1" }
variable "image"       { default = "hashicorp/nomad-c1m:0.1" }

resource "template_file" "docker" {
  template = "${file("${path.module}/docker.nomad.tpl")}"

  vars {
    region      = "${var.region}"
    datacenters = "${var.datacenters}"
    priority    = "${var.priority}"
    count       = "${var.count}"
    image       = "${var.image}"
  }
}

resource "template_file" "consul_docker" {
  template = "${file("${path.module}/consul_docker.nomad.tpl")}"

  vars {
    region      = "${var.region}"
    datacenters = "${var.datacenters}"
    priority    = "${var.priority}"
    count       = "${var.count}"
    image       = "${var.image}"
  }
}

resource "template_file" "raw_exec" {
  template = "${file("${path.module}/raw_exec.nomad.tpl")}"

  vars {
    region      = "${var.region}"
    datacenters = "${var.datacenters}"
    priority    = "${var.priority}"
    count       = "${var.count}"
  }
}

resource "template_file" "consul_raw_exec" {
  template = "${file("${path.module}/consul_raw_exec.nomad.tpl")}"

  vars {
    region      = "${var.region}"
    datacenters = "${var.datacenters}"
    priority    = "${var.priority}"
    count       = "${var.count}"
  }
}

output "docker_job"          { value = "${template_file.docker.rendered}" }
output "consul_docker_job"   { value = "${template_file.consul_docker.rendered}" }
output "raw_exec_job"        { value = "${template_file.raw_exec.rendered}" }
output "consul_raw_exec_job" { value = "${template_file.consul_raw_exec.rendered}" }
