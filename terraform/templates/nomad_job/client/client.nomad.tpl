job "client" {
  region      = "${region}"
  datacenters = [${datacenters}]
  type        = "service"
  priority    = ${priority}

  constraint {
    attribute = "\$${node.datacenter}"
    regexp    = "(${replace(replace(join("|", split(",", datacenters)), "\"", ""), " ", "")})"
  }

  update {
    stagger      = "1s"
    max_parallel = 3
  }

  group "client" {
    count = ${count}

    restart {
      mode     = "delay"
      interval = "5m"
      attempts = 10
      delay    = "25s"
    }

    task "client" {
      driver       = "exec"
      kill_timeout = "10s"

      config {
        command = "${command}"
      }

      artifact {
        source = "${artifact_source}"
      }

      resources {
        cpu    = 20
        memory = 15
        disk   = 10

        network {
          mbits = 1

          port "client" {
          }
        }
      }

      logs {
        max_files     = 1
        max_file_size = 5
      }

      env {
        NODE_DATACENTER = "\$${node.datacenter}"
        REDIS_ADDRESS   = "redis.query.consul:6379"
        REQUEST_ADDRESS = "${request_address}"
      }

      service {
        name = "client"
        port = "client"
        tags = [${tags}]

        /*
        check {
          name     = "client alive"
          type     = "http"
          path     = "/health"
          interval = "10s"
          timeout  = "2s"
        }
        */
      }
    }
  }
}
