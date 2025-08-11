terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "my-first-bucket" {
  bucket = "my-tf-test-bucket-hueheuheuheuehhueheu123"
 

  tags = {
    Name = "My bucket"
    
  }
  

}


resource "aws_iam_role" "lambda_role" {
  name = "${var.app}-lambda-role"


  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
    }]
  })
}

  resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.s3_write_policy.arn
}

resource "aws_iam_policy" "s3_write_policy" {
  name   = "${var.app}-s3-write-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = ["s3:PutObject"],
      Effect   = "Allow",
      Resource = "${aws_s3_bucket.my-first-bucket.arn}/*" 
    }]
  })
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/app"
  output_path = "${path.module}/app.zip"
}

resource "aws_lambda_function" "robo_diario" {
  function_name = "${var.app}-robo-diario"
  role          = aws_iam_role.lambda_role.arn
  handler       = "main.handler" 
  runtime       = "python3.9"
  filename      = data.archive_file.lambda_zip.output_path

  # Passa o nome do bucket para o código Python
  environment {
    variables = {
      TARGET_BUCKET_NAME = aws_s3_bucket.my-first-bucket.id
    }
  }
}
resource "aws_cloudwatch_event_rule" "despertador" {
  name                = "${var.app}-despertador"
  description         = "Dispara a tarefa diariamente às 10h UTC"
  
  # cron(minuto hora dia-do-mês mês dia-da-semana ano)
  # '0 10 * * ? *' significa: às 10:00, em qualquer dia, em qualquer mês.
  # IMPORTANTE: A hora é em UTC (horário de Londres). 10h UTC são 7h da manhã no horário de Brasília.
  # Se quisesse 10h no horário de Brasília (UTC-3), usaria '0 13 * * ? *'
  schedule_expression = "cron(0 13 * * ? *)" 
}

resource "aws_cloudwatch_event_target" "aciona_lambda" {
  rule = aws_cloudwatch_event_rule.despertador.name
  arn  = aws_lambda_function.robo_diario.arn
}


resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.robo_diario.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.despertador.arn
}


resource "random_id" "sufixo" {
  byte_length = 4
}