terraform {
  backend "s3" {
    bucket = "terraform-state-file12345"
    key    = "eks/terraform.tfstate"
    region = "ap-south-1"
  }
}