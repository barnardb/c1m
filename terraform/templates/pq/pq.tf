variable "consul_join_name" { }
variable "tags"             { }

resource "template_file" "pq_catch_all" {
  template = "${file("${path.module}/pq_catch_all.sh.tpl")}"

  vars {
    consul_join_name = "${var.consul_join_name}"
    tags             = "${var.tags}"
  }
}

output "catch_all_script" { value = "${template_file.pq_catch_all.rendered}" }
