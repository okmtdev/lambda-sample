resource "aws_ecr_repository" "lambda_sample_ecr" {
  name                 = "lambda-sample-ecr"
  image_tag_mutability = "MUTABLE"
  force_delete         = false

  # https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-scanning.html
  image_scanning_configuration {
    scan_on_push = true
  }
}
