resource "aws_ecr_repository" "lambda_sample" {
  name                 = "lambda-sample"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
