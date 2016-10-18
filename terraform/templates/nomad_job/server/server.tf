variable "region"          { default = "global" }
variable "datacenters"     { }
variable "priority"        { default = "50" }
variable "count"           { default = "1" }
variable "artifact_source" { }
variable "command"         { }
variable "tags"            { default = "\"global\"" }

resource "template_file" "server" {
  template = "${file("${path.module}/server.nomad.tpl")}"

  vars {
    region          = "${var.region}"
    datacenters     = "${var.datacenters}"
    count           = "${var.count}"
    priority        = "${var.priority}"
    artifact_source = "${var.artifact_source}"
    command         = "${var.command}"
    tags            = "${var.tags}"
  }
}

output "job"   { value = "${template_file.server.rendered}" }
