## General Variables
variable "app_name" {
  type = string
  default = "my-app"
  description = "The name of the application."
}

## TFC Variables

variable "oauth_client_id" {
  type = string
}

## AWS Variables
variable "aws_vpc_id" {
  type = string
}

variable "aws_public_subnet_id" {
  type = string
}

variable "aws_private_subnet_id" {
  type = string
}

variable "aws_s3_bucket_arn" {
  type = string
}

variable "aws_access_key_id" {
  type = string
}

variable "aws_secret_access_key" {
  type = string
  sensitive = true
}

## GitLab Variables

variable "gitlab_group_path" {
  type = string
  description = "Value for the full_path attribute of the gitlab_group resource to add the new app repo to"
}