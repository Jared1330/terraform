output "dev_ecr_name" {
  value = module.vpc-dev.name
}

output "dev_arn_name" {
  value = module.vpc-dev.arn
}

output "qa_ecr_name" {
  value = module.vpc-qa.name
}

output "qa_arn_name" {
  value = module.vpc-qa.arn
}
