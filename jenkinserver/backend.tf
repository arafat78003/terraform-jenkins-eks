#dont make use of variables

terraform {
  backend "s3" {
    bucket = "terraform-state-file12345"
    key    = "jenkins/terraform.tfstate"
    region = "ap-south-1"
  }
}