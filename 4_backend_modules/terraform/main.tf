module "vpc-dev" {
  source = "../terraform-modules/ecr"
  env    = "dev"
}

module "vpc-qa" {
  source = "../terraform-modules/ecr"
  env    = "qa"
}

