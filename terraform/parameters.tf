resource "aws_ssm_parameter" "teste" {
  name  = format("%s-exemplo-teste", var.service_name)
  type  = "String"
  value = "Vim do Parameter Store v2"
}