# variable "tfc_token" {
#   type = string
# }

# variable "tfc_org" {
#   type = string
# }

variable "oauth_client_id" {
  type = string
}

variable "app_name" {
  type = string
  description = "The name of the application. Must end with `-app`"

  validation {
    condition     = length(var.app_name) > 4 && substr(var.app_name, -4, -1) == "-app"
    error_message = "The app_name value must be greater than 4 characters and end with \"-app\"."
  }
}

# variable "gitlab_token" {
#   type = string
# }

# variable "gitlab_base_url" {
#   type    = string
# }

# variable "tfe_oauth_client_name" {
#   type = string
#   default = "instruqt-learners-gitlab"
# }

variable "gitlab_group_path" {
  type = string
  description = "Value for the full_path attribute of the gitlab_group resource to add the new app repo to"
}