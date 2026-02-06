resource "aws_apigatewayv2_api" "crud_api" {
  name          = var.name
  protocol_type = "HTTP"
}

# CORREÇÃO: Substituído aws_api_gateway_integration por aws_apigatewayv2_integration.
# Nota: O tipo "MOCK" não é suportado no HTTP API (v2). Usamos HTTP_PROXY como placeholder.
resource "aws_apigatewayv2_integration" "mock" {
  api_id             = aws_apigatewayv2_api.crud_api.id
  integration_type   = "HTTP_PROXY" # Tipo válido para HTTP API.
  integration_uri    = "http://example.com" # Exemplo de URI. Ajuste conforme sua integração real.
  integration_method = "GET"
}

# CORREÇÃO: Substituído aws_api_gateway_route por aws_apigatewayv2_route.
resource "aws_apigatewayv2_route" "get_root" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "GET /${var.root_path}"
  target    = "integrations/${aws_apigatewayv2_integration.mock.id}"
}


resource "aws_apigatewayv2_stage" "dev" {
  api_id      = aws_apigatewayv2_api.crud_api.id
  name        = var.stage_name
  auto_deploy = true
}

# --- Exemplo de integração Lambda para autenticação CPF ---
# resource "aws_lambda_function" "auth_cpf" {
#   function_name = "auth-cpf"
#   # ...configuração da função Lambda...
# }
#
# resource "aws_api_gateway_integration" "lambda_auth_cpf" {
#   api_id           = aws_api_gateway_http_api.crud_api.id
#   integration_type = "AWS_PROXY"
#   integration_uri  = aws_lambda_function.auth_cpf.invoke_arn
# }
#
# resource "aws_api_gateway_route" "auth_cpf" {
#   api_id    = aws_api_gateway_http_api.crud_api.id
#   route_key = "POST /auth/cpf"
#   target    = "integrations/${aws_api_gateway_integration.lambda_auth_cpf.id}"
# }

# --- Exemplo de integração Lambda para autenticação USER ---
# resource "aws_lambda_function" "auth_user" {
#   function_name = "auth-user"
#   # ...configuração da função Lambda...
# }
#
# resource "aws_api_gateway_integration" "lambda_auth_user" {
#   api_id           = aws_api_gateway_http_api.crud_api.id
#   integration_type = "AWS_PROXY"
#   integration_uri  = aws_lambda_function.auth_user.invoke_arn
# }
#
# resource "aws_api_gateway_route" "auth_user" {
#   api_id    = aws_api_gateway_http_api.crud_api.id
#   route_key = "POST /auth/user"
#   target    = "integrations/${aws_api_gateway_integration.lambda_auth_user.id}"
# }