# Sets the "backend" used to store Terraform state.
# This is required to make continous delivery work.

terraform {
  backend "gcs" {
    bucket  = "flixtubeakshatsit722"
    prefix  = "terraform/state"
  }
}
