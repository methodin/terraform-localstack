variable "region" {
  default = "us-east-1"
}

variable "deploy_bucket" {
  default = "deploy"
}

data "aws_caller_identity" "current" {}

provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    key    = "app"
    region = "us-east-1"
  }
}

module "core" {
  source = "../modules/core"
}
