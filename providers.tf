# terraform {
#   required_providers {
#     tfe = {
#       source  = "hashicorp/tfe"
#       version = "~> 0.50.0"
#     }
#     gitlab = {
#       source  = "gitlabhq/gitlab"
#       version = "~> 16.6.0"
#     }
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.30.0"
#     }
#   }
# }

provider "aws" {
  region = "us-west-2"
}

provider "tfe" {
  hostname = "app.terraform.io"
  # token    = var.tfc_token
}

# provider "gitlab" {
#   # token    = var.gitlab_token
#   # base_url = var.gitlab_base_url
# }