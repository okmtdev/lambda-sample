terraform {
  required_version = ">= 1.6.3"
  backend "s3" {
    bucket  = "happy-wedding-tfstate"
    region  = "ap-northeast-1"
    key     = "terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      service   = var.service_name
      owner     = "okmtdev"
      terraform = "true"
    }
  }
}
