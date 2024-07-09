resource "aws_efs_file_system" "main" {
  creation_token   = format("%s-efs", var.service_name)
  performance_mode = "generalPurpose"
}

resource "aws_security_group" "efs" {
  name        = "efs_sg"
  description = format("%s-efs", var.service_name)
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_efs_mount_target" "mount_subnet_1" {
  file_system_id = aws_efs_file_system.main.id
  subnet_id      = data.aws_ssm_parameter.private_subnet_1.value
  security_groups = [
    aws_security_group.efs.id
  ]
}

resource "aws_efs_mount_target" "mount_subnet_2" {
  file_system_id = aws_efs_file_system.main.id
  subnet_id      = data.aws_ssm_parameter.private_subnet_2.value
  security_groups = [
    aws_security_group.efs.id
  ]
}

resource "aws_efs_mount_target" "mount_subnet_3" {
  file_system_id = aws_efs_file_system.main.id
  subnet_id      = data.aws_ssm_parameter.private_subnet_3.value
  security_groups = [
    aws_security_group.efs.id
  ]
}