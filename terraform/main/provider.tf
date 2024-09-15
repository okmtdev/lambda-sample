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
  region = "ap-northeast-1"
}
