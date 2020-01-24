
terraform {
  required_version = ">= 0.12"
}

module "redis" {
  source                  = "../.."
  is_test                 = true

  env                     = var.env
  name                    = "${var.env}-mergermarket"
  redis_clusters          = "2"
  redis_failover          = "false"
  subnets                 = [var.platform_config["private_subnets"]]
  vpc_id                  = var.platform_config["vpc"]
  redis_node_type         = "cache.t2.micro"
  allowed_security_groups = [var.platform_config["ecs_cluster.default.security_group"]]
  allowed_cidr            = ["10.169.112.0/21"]
}

# configure provider to not try too hard talking to AWS API
provider "aws" {
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_get_ec2_platforms      = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
  max_retries                 = 1
  access_key                  = "a"
  secret_key                  = "a"
  region                      = "eu-west-1"
}

# variables
variable "env" {}

variable "platform_config" {
}

variable "aws_account_alias" {}