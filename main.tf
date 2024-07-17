# Initialize and apply the AWS Simple Landing Zone module
module "aws-simple-lz" {
  source = "./modules/aws-simple-lz"

  app_name = var.app_name
}

# Initialize and apply the Terraform Cloud Simple Landing Zone module
module "tfc-simple-lz" {
  source  = "./modules/tfc-simple-lz"
  # tfc_org = var.tfc_org

  app_name              = var.app_name
  # gitlab_token          = var.gitlab_token
  # gitlab_base_url       = var.gitlab_base_url
  aws_vpc_id            = module.aws-simple-lz.vpc_id
  aws_public_subnet_id  = module.aws-simple-lz.public_subnet_id
  aws_private_subnet_id = module.aws-simple-lz.private_subnet_id
  aws_s3_bucket_arn     = module.aws-simple-lz.s3_bucket_arn
  aws_access_key_id     = module.aws-simple-lz.aws_access_key_id
  aws_secret_access_key = module.aws-simple-lz.aws_secret_access_key
  gitlab_group_path     = var.gitlab_group_path
  oauth_client_id       = var.oauth_client_id
}