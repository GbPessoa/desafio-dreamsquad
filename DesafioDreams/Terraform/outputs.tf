output "my-bucket_s3" {
  description = "O nome do bucket S3 onde os arquivos serão salvos."
  value       = aws_s3_bucket.my-first-bucket.id
}

output "o_lambda" {
  description = "O nome do 'robô' (função Lambda)."
  value       = aws_lambda_function.robo_diario.function_name
}

output "regra_do_despertador" {
  description = "O nome da regra do 'despertador' (EventBridge)."
  value       = aws_cloudwatch_event_rule.despertador.name
}