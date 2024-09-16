module "ecr" {
  source = "../modules/ecr"
  name   = "lambda-sample-ecr"
}

data "aws_caller_identity" "current" {}

resource "aws_lambda_function" "function" {
  function_name = "lambda-sample-function"
  role          = aws_iam_role.lambda.arn
  image_uri     = "${module.ecr.repository.repository_url}:latest"
  package_type  = "Image"

  timeouts {
    create = "15m"
  }
}

resource "aws_iam_role" "lambda-sample-role" {
  name = "lambda-sample-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
