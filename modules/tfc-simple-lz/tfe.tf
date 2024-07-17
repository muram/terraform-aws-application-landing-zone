# Create a project in Terraform Cloud
resource "tfe_project" "app" {
  name         = "Project-${var.app_name}"
}

# Create a workspace in the project
resource "tfe_workspace" "app_ws" {
  for_each = local.branches

  name           = "${var.app_name}-ws-${each.key}"
  project_id     = tfe_project.app.id
  queue_all_runs = false
  auto_apply     = true
  depends_on     = [ time_sleep.wait_5_sec ]
  vcs_repo {
    identifier     = "${var.gitlab_group_path}/${var.app_name}-repo"
    oauth_token_id = data.tfe_oauth_client.client.oauth_token_id
    branch         = each.key
  }
}

# Add extra time for branch creation before connecting workspaces.
# Note: This sleep timer was added because the workspaces were failing to 
# fetch the configuration even when depending on the final branch creation. 
# This extra buffer time seems to fix the issue.
resource "time_sleep" "wait_5_sec" {
  depends_on = [ gitlab_branch.dev ]
  
  create_duration = "5s"
}

# Initiate the first run of the workspace
resource "tfe_workspace_run" "initial_run" {
  for_each = tfe_workspace.app_ws
  workspace_id = each.value.id

  apply {
    manual_confirm = false
    wait_for_run   = false
  }
  depends_on = [ 
    tfe_variable.aws_vpc_id,
    tfe_variable.aws_public_subnet_id,
    tfe_variable.aws_private_subnet_id,
    tfe_variable.aws_s3_bucket_arn,
    tfe_variable.aws_access_key_id,
    tfe_variable.aws_secret_access_key
   ]
}

# Create a team in Terraform Cloud
resource "tfe_team" "app_admins" {
  name         = "${var.app_name}-admins"
}

# Create a Terraform variable in the workspace
resource "tfe_variable" "aws_vpc_id" {
  for_each     = tfe_workspace.app_ws

  key          = "aws_vpc_id"
  value        = var.aws_vpc_id
  category     = "terraform"
  workspace_id = each.value.id
}

# Create another Terraform variable in the workspace
resource "tfe_variable" "aws_public_subnet_id" {
  for_each     = tfe_workspace.app_ws

  key          = "aws_public_subnet_id"
  value        = var.aws_public_subnet_id
  category     = "terraform"
  workspace_id = each.value.id
}

# Create another Terraform variable in the workspace
resource "tfe_variable" "aws_private_subnet_id" {
  for_each     = tfe_workspace.app_ws

  key          = "aws_private_subnet_id"
  value        = var.aws_private_subnet_id
  category     = "terraform"
  workspace_id = each.value.id
}

# Create another Terraform variable in the workspace
resource "tfe_variable" "aws_s3_bucket_arn" {
  for_each     = tfe_workspace.app_ws
  
  key          = "aws_s3_bucket_arn"
  value        = var.aws_s3_bucket_arn
  category     = "terraform"
  workspace_id = each.value.id
}

# Create another Terraform variable in the workspace
resource "tfe_variable" "aws_access_key_id" {
  for_each     = tfe_workspace.app_ws

  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key_id
  category     = "env"
  workspace_id = each.value.id
}

# Create another Terraform variable in the workspace
resource "tfe_variable" "aws_secret_access_key" {
  for_each     = tfe_workspace.app_ws
  
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_access_key
  category     = "env"
  workspace_id = each.value.id
  sensitive    = true
}

resource "tfe_variable" "app_name" {
  for_each     = tfe_workspace.app_ws
  
  key          = "app_name"
  value        = var.app_name
  category     = "terraform"
  workspace_id = each.value.id
}

# Assign team access to the project
resource "tfe_team_project_access" "app_admins" {
  access     = "write"
  team_id    = tfe_team.app_admins.id
  project_id = tfe_project.app.id
}

# Get VCS OAuth Connection
data "tfe_oauth_client" "client" {
  oauth_client_id = var.oauth_client_id
}
