job "web" {
  region      = "${region}"
  datacenters = [${datacenters}]
  type        = "service"
  priority    = ${priority}

  update {
    stagger      = "10s"
    max_parallel = 1
  }

  group "nginx" {
    count = ${nginx_count}

    restart {
      mode     = "fail"
      attempts = 3
      interval = "5m"
      delay    = "2s"
    }

    task "nginx" {
      driver = "docker"

      config {
        image        = "${nginx_image}"
        network_mode = "host"
      }

      resources {
        cpu    = 20
        memory = 15
        disk   = 10

        network {
          mbits = 1

          port "nginx" {
            static = 80
          }
        }
      }

      logs {
        max_files     = 1
        max_file_size = 5
      }

      service {
        name = "nginx"
        port = "nginx"
        tags = [${nginx_tags}]

        check {
          name     = "nginx alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }

  group "nodejs" {
    count = ${nodejs_count}

    restart {
      mode     = "fail"
      attempts = 3
      interval = "5m"
      delay    = "2s"
    }

    task "nodejs" {
      driver = "docker"

      config {
        image        = "${nodejs_image}"
        network_mode = "host"
      }

      resources {
        cpu    = 20
        memory = 15
        disk   = 10

        network {
          mbits = 1

          # Request for a dynamic port
          port "nodejs" {
          }
        }
      }

      logs {
        max_files     = 1
        max_file_size = 5
      }

      env {
        REDIS_ADDR = "redis.query.consul"
        REDIS_PORT = "6379"
        NODE_CLASS = "\$${node.class}"
      }

      service {
        name = "nodejs"
        port = "nodejs"
        tags = [${nodejs_tags}]

        check {
          name     = "nodejs alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }

        check {
          name     = "nodejs running on port 8080"
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "1s"
        }
      }
    }
  }
}
