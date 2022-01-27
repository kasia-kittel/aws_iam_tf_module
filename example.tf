terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

module "prod_ci_iam" {
  source     = "./modules/aws-ci-iam"
  env_suffix = "prod"
  additional_tags = {
    creator = "terraform"
  }
}

output "prod_ci_role" {
  value = module.prod_ci_iam.ci_role.name
}

output "prod_ci_policy" {
  value = module.prod_ci_iam.ci_policy.name
}

output "prod_ci_group" {
  value = module.prod_ci_iam.ci_group.name
}

output "ci_user" {
  value = module.prod_ci_iam.ci_user.name
}
