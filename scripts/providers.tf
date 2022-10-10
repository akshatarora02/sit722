# Initialises Terraform providers and sets their version numbers.

provider "google" {
    project = var.gcp_project
    region = var.location
}
data "google_client_config" "provider" {}

data "google_container_cluster" "cluster" {
  name     = var.app_name
  location = var.location
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate,
  )
}


provider "tls" {
}
