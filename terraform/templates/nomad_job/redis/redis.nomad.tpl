job "redis" {
  region      = "${region}"
  datacenters = [${datacenters}]
  type        = "service"
  priority    = ${priority}

  update {
    stagger      = "1s"
    max_parallel = 1
  }

  group "redis" {
    count = ${count}

    restart {
      mode     = "delay"
      interval = "5m"
      attempts = 10
      delay    = "25s"
    }

    task "redis" {
      driver = "docker"

      config {
        image = "${image}"

        port_map {
          redis = 6379
        }
      }

      resources {
        cpu    = 20
        memory = 15
        disk   = 10

        network {
          mbits = 1

          port "redis" {
            static = 6379
          }
        }
      }

      logs {
        max_files     = 1
        max_file_size = 5
      }

      service {
        name = "redis"
        port = "redis"
        tags = [${tags}]

        check {
          name     = "redis alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
