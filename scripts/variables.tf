# Sets global variables for this Terraform project.
variable "gcp_project" {
  default = "sit722-22t2-arora-9ce3921"
}
variable app_name {
    default = "flixtube"
}
variable location {
  default = "australia-southeast2"
}

variable admin_username {
  default = "linux_admin"
}

variable "gcp_auth_file" {
  type        = string
  description = "GCP authentication file"
}

variable "bucket-name" {
  type        = string
  description = "The name of the Google Storage Bucket to create"
  default = "flixtubeakshatsit722"
}
variable "storage-class" {
  type        = string
  description = "The storage class of the Storage Bucket to create"
}

variable app_version { # Can't be called version! That's a reserved word.
}

variable client_id {

}

variable client_secret {

}
