variable "region"      { default = "global" }
variable "datacenters" { }
variable "priority"    { default = "50" }
variable "count"       { default = "1" }
variable "image"       { }
variable "tags"        { default = "\"global\"" }

resource "template_file" "redis" {
  template = "${file("${path.module}/redis.nomad.tpl")}"

  vars {
    region      = "${var.region}"
    datacenters = "${var.datacenters}"
    count       = "${var.count}"
    priority    = "${var.priority}"
    image       = "${var.image}"
    tags        = "${var.tags}"
  }
}

output "job" { value = "${template_file.redis.rendered}" }
