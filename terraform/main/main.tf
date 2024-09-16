module "ecr" {
  source = "../modules/ecr"
  name   = "lambda-sample-ecr"
}

resource "aws_lambda_function" "function" {
  function_name = "lambda-sample-function"
  role          = aws_iam_role.api.arn
  package_type  = "Image"
  memory_size   = "512"
  timeout       = "60"
  image_uri     = "${module.ecr.repository.repository_url}:latest"

  timeouts {
    create = "15m"
  }

  depends_on = [module.ecr]
}

resource "aws_lambda_function_url" "function-url" {
  function_name      = aws_lambda_function.function.function_name
  authorization_type = "NONE"
  cors {
    allow_credentials = false
    allow_headers = [
      "*",
    ]
    allow_methods = [
      "*",
    ]
    allow_origins = [
      "*",
    ]
    expose_headers = [
      "*",
    ]
    max_age = 0
  }
}

resource "aws_iam_role" "api" {
  name                 = "lambda_minimum_serverless_api_role"
  description          = "Allows api of lambda to call AWS services."
  assume_role_policy   = data.aws_iam_policy_document.api_assume_policy.json
  max_session_duration = "3600"
}


data "aws_iam_policy_document" "api_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = [
        "lambda.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_lambda_permission" "api_url" {
  statement_id           = "FunctionURLAllowPublicAccess"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.function.arn
  function_url_auth_type = "NONE"
  principal              = "*"
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.api.name
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

//resource "aws_apigatewayv2_route" "route_health" {
//  api_id    = aws_apigatewayv2_api.api.id
//  route_key = "ANY /health"
//  target    = "integrations/${aws_apigatewayv2_integration.integration.id}"
//}
//
//
//resource "aws_apigatewayv2_route" "route_peco" {
//  api_id    = aws_apigatewayv2_api.api.id
//  route_key = "GET /peco"
//  target    = "integrations/${aws_apigatewayv2_integration.integration.id}"
//}

resource "aws_apigatewayv2_route" "route_all" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.integration.id}"
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn
    format = jsonencode({
      "requestId"      = "$context.requestId",
      "ip"             = "$context.identity.sourceIp",
      "requestTime"    = "$context.requestTime",
      "httpMethod"     = "$context.httpMethod",
      "routeKey"       = "$context.routeKey",
      "status"         = "$context.status",
      "protocol"       = "$context.protocol",
      "responseLength" = "$context.responseLength"
    })
  }
}

resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/apigateway/lambda-sample-api"
  retention_in_days = 90
}
