variable "region"       { default = "global" }
variable "datacenters"  { }
variable "priority"     { default = "50" }
variable "nginx_count"  { default = "1" }
variable "nginx_image"  { default = "hashidemo/nginx:latest" }
variable "nginx_tags"   { default = "\"global\"" }
variable "nodejs_count" { default = "3" }
variable "nodejs_image" { default = "hashidemo/nodejs:latest" }
variable "nodejs_tags"  { default = "\"global\"" }

resource "template_file" "web" {
  template = "${file("${path.module}/web.nomad.tpl")}"

  vars {
    region       = "${var.region}"
    datacenters  = "${var.datacenters}"
    priority     = "${var.priority}"
    nginx_count  = "${var.nginx_count}"
    nginx_image  = "${var.nginx_image}"
    nginx_tags   = "${var.nginx_tags}"
    nodejs_count = "${var.nodejs_count}"
    nodejs_image = "${var.nodejs_image}"
    nodejs_tags  = "${var.nodejs_tags}"
  }
}

output "job" { value = "${template_file.web.rendered}" }
