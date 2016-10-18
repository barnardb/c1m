variable "region"          { default = "global" }
variable "datacenters"     { }
variable "priority"        { default = "50" }
variable "count"           { default = "1" }
variable "artifact_source" { }
variable "command"         { }
variable "request_address" { }
variable "tags"            { default = "\"global\"" }

resource "template_file" "client" {
  template = "${file("${path.module}/client.nomad.tpl")}"

  vars {
    region          = "${var.region}"
    datacenters     = "${var.datacenters}"
    count           = "${var.count}"
    priority        = "${var.priority}"
    artifact_source = "${var.artifact_source}"
    command         = "${var.command}"
    request_address = "${var.request_address}"
    tags            = "${var.tags}"
  }
}

output "job" { value = "${template_file.client.rendered}" }
