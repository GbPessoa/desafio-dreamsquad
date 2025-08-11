variable "aws_region" {
  description = "A região da AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-1"
}

variable "app" {
  description = "Desafio Dreams"
  type        = string
  default     = "desafio-tf"
}