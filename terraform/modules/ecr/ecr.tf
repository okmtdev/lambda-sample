resource "aws_ecr_repository" "repos" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"
  force_delete         = false

  image_scanning_configuration {
    scan_on_push = true
  }
}
