name              = "c1m"
atlas_environment = "c1m-gce"
atlas_username    = "REPLACE_IN_ATLAS"
atlas_token       = "REPLACE_IN_ATLAS"
project_id        = "REPLACE_IN_ATLAS"
credentials       = "REPLACE_IN_ATLAS" # GCE account credentials
ssh_keys          = "REPLACE_IN_ATLAS" # Added to all GCE instances and must be prefixed by the user ID which is allowed
private_key       = "REPLACE_IN_ATLAS"

cidr               = "10.140.0.0/16"
artifact_type      = "google.image"
consul_log_level   = "INFO"
nomad_log_level    = "INFO"
nomad_datacenters  = "\"gce-us-central1\", \"gce-us-east1\", \"gce-europe-west1\", \"gce-asia-east1\""
nomad_node_classes = "5" # Number of node_classes we will be using for the challenge

us_central1_zones  = "us-central1-b,us-central1-c,us-central1-f" # us-central1-a doesn't have n1_standard_32
us_east1_zones     = "us-east1-b,us-east1-c,us-east1-d"
europe_west1_zones = "europe-west1-c,europe-west1-b,europe-west1-d" # europe-west1-b doesn't have n1_standard_32
asia_east1_zones   = "asia-east1-a,asia-east1-b,asia-east1-c"

consul_server_artifact_name    = "c1m-consul-server"
consul_server_artifact_version = "latest"
consul_server_machine          = "n1-standard-32"
consul_server_disk             = "10" # In GB
consul_servers                 = "3"

nomad_server_artifact_name    = "c1m-nomad-server"
nomad_server_artifact_version = "latest"
nomad_server_machine          = "n1-standard-32"
nomad_server_disk             = "500" # In GB
nomad_servers                 = "5"
nomad_server_join             = "nomad-server?passing"

nomad_client_artifact_name    = "c1m-nomad-client"
nomad_client_artifact_version = "latest"
nomad_client_machine          = "n1-standard-8"
nomad_client_disk             = "20" # In GB
nomad_client_groups           = "10"
nomad_clients                 = "5000"
nomad_client_join             = "nomad-server?dc=gce-us-central1&passing"

utility_artifact_name    = "c1m-utility"
utility_artifact_version = "latest"
utility_machine          = "n1-standard-8"
utility_disk             = "50" # In GB
