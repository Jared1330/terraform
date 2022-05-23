resource "aws_ecr_repository" "ecr_grafana-wizzy" {
  name                 = "aws-${var.env}-grafana-wizzy"
  image_tag_mutability = "MUTABLE"
}
