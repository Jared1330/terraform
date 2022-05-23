output "name" {
  value       = aws_ecr_repository.ecr_grafana-wizzy.name
  description = "Name of created ECR"
}

output "arn" {
  value       = aws_ecr_repository.ecr_grafana-wizzy.arn
  description = "Arn of created ECR"
}
