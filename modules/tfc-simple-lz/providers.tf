terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.50.0"
    }
    gitlab = {
      source = "gitlabhq/gitlab"
      version = "~> 16.6.0"
    }
  }
}