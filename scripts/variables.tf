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

variable "bucket-name" {
  type        = string
  description = "The name of the Google Storage Bucket to create"
  default = "flixtubeakshatsit722"
}

variable app_version { 
  default = 1
}

