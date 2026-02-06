output "http_api_id" {
  description = "ID do API Gateway HTTP API"
  # CORREÇÃO: Referência ao recurso V2 (aws_apigatewayv2_api.crud_api).
  value       = aws_apigatewayv2_api.crud_api.id 
}

output "stage_name" {
  description = "Nome do stage do API Gateway"
  # CORREÇÃO: Referência ao recurso V2 de Stage (aws_apigatewayv2_stage.dev).
  value       = aws_apigatewayv2_stage.dev.name 
}