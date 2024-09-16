module "ecr" {
  source = "../modules/ecr"
  name   = "lambda-sample-ecr"
}

resource "aws_lambda_function" "function" {
  function_name = "lambda-sample-function"
  role          = aws_iam_role.lambda-sample-role.arn
  image_uri     = "${module.ecr.repository.repository_url}:latest"
  package_type  = "Image"

  timeouts {
    create = "15m"
  }
}

resource "aws_lambda_function_url" "function-url" {
  function_name      = aws_lambda_function.function.function_name
  authorization_type = "NONE"
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
  role       = aws_iam_role.lambda-sample-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_apigatewayv2_api" "api" {
  name          = "lambda-sample-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "integration" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.function.invoke_arn
}

resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "ANY /"
  target    = "integrations/${aws_apigatewayv2_integration.integration.id}"
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}
