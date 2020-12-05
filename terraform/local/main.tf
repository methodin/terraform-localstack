variable "region" {
  default = "us-east-1"
}

variable "deploy_bucket" {
  default = "deploy-local"
}

data "aws_caller_identity" "current" {}

provider "aws" {
  access_key                  = "mock_access_key"
  region                      = var.region
  s3_force_path_style         = true
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway       = "http://localstack:4566"
    cloudformation   = "http://localstack:4566"
    cloudwatch       = "http://localstack:4566"
    cloudwatchevents = "http://localstack:4566"
    dynamodb         = "http://localstack:4566"
    es               = "http://localstack:4566"
    firehose         = "http://localstack:4566"
    iam              = "http://localstack:4566"
    kinesis          = "http://localstack:4566"
    lambda           = "http://localstack:4566"
    route53          = "http://localstack:4566"
    redshift         = "http://localstack:4566"
    s3               = "http://localstack:4572"
    secretsmanager   = "http://localstack:4566"
    ses              = "http://localstack:4566"
    sns              = "http://localstack:4566"
    sqs              = "http://localstack:4566"
    ssm              = "http://localstack:4566"
    stepfunctions    = "http://localstack:4566"
    sts              = "http://localstack:4566"
  }
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

# local only terraform infra
module "local" {
  source = "../modules/local"
}
