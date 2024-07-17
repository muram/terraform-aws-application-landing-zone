locals {
  branches = toset(["dev", "stage", "prod"])
  files  = {
    "main.tf"      = base64encode("# Insert your Terrfaorm code here"),
    "providers.tf" = base64encode("# Insert your Terrfaorm code here"),
    "outputs.tf"   = base64encode("# Insert your Terrfaorm code here"),
    "README.md"    = base64encode("# Insert your README documentation here"),
    "variables.tf" = base64encode(<<EOF
variable "aws_s3_bucket_arn" {
  type = string
  description = "The ARN of the S3 bucket to use for the application."
}

variable "aws_public_subnet_id" {
  type = string
  description = "The ID of the public subnet to use for the application."
}

variable "aws_private_subnet_id" {
  type = string
  description = "The ID of the private subnet to use for the application."
}

variable "aws_vpc_id" {
  type = string
  description = "The ID of the VPC to use for the application."
}

variable "app_name" {
  type = string
  description = "The name of the application."
}

EOF
    )
  }
}

# Reference existing group in Gitlab
data "gitlab_group" "instruqt_group" {
  full_path = var.gitlab_group_path
}

# Creates a new project under the Instruqt Group.0
resource "gitlab_project" "app_repo" {
  name                             = "${var.app_name}-repo"
  namespace_id                     = data.gitlab_group.instruqt_group.id
  visibility_level                 = "public"
  default_branch                   = "prod"
  remove_source_branch_after_merge = false
  initialize_with_readme           = false
}

resource "gitlab_branch" "stage" {
  depends_on = [gitlab_repository_file.main]

  name    = "stage"
  ref     = "prod"
  project = gitlab_project.app_repo.id
}

resource "gitlab_branch" "dev" {
  depends_on = [gitlab_branch.stage]

  name    = "dev"
  ref     = "stage"
  project = gitlab_project.app_repo.id
}

# Add an initial file to the project
resource "gitlab_repository_file" "main" {
  for_each = local.files

  project        = gitlab_project.app_repo.id
  file_path      = each.key
  branch         = "prod"
  content        = each.value
  commit_message = "Initial onboard commit"
}