module "service" {
  source = "github.com/msfidelis/linuxtips-curso-containers-ecs-service-module?ref=v1.3.0"
  # source                      = "/Users/matheus/Workspace/linuxtips/linuxtips-curso-containers-ecs-service-module"
  region                      = var.region
  cluster_name                = var.cluster_name
  service_name                = var.service_name
  service_port                = var.service_port
  service_cpu                 = var.service_cpu
  service_memory              = var.service_memory
  service_listener            = data.aws_ssm_parameter.listener.value
  service_task_execution_role = aws_iam_role.main.arn
  service_healthcheck         = var.service_healthcheck
  service_launch_type         = var.service_launch_type
  service_task_count          = var.service_task_count
  service_hosts               = var.service_hosts

  container_image = var.container_image

  environment_variables = var.environment_variables

  secrets = [
    {
      name      = "VARIAVEL_COM_VALOR_DO_SSM"
      valueFrom = aws_ssm_parameter.teste.arn
    },
    {
      name      = "VARIAVEL_COM_VALOR_DO_SECRETS"
      valueFrom = aws_secretsmanager_secret.teste.arn
    }
  ]

  capabilities = var.capabilities

  vpc_id = data.aws_ssm_parameter.vpc_id.value
  private_subnets = [
    data.aws_ssm_parameter.private_subnet_1.value,
    data.aws_ssm_parameter.private_subnet_2.value,
    data.aws_ssm_parameter.private_subnet_3.value,
  ]

  efs_volumes = [
    {
      volume_name      = "volume-de-exemplo"
      file_system_id   = aws_efs_file_system.main.id
      file_system_root = "/"
      mount_point      = "/mnt/efs"
      read_only        = false
    }
  ]

  # Autoscaling

  scale_type = var.scale_type

  task_minimum = var.task_minimum
  task_maximum = var.task_maximum

  ### Autoscaling de CPU

  scale_out_cpu_threshold       = var.scale_out_cpu_threshold
  scale_out_adjustment          = var.scale_out_adjustment
  scale_out_comparison_operator = var.scale_out_comparison_operator
  scale_out_statistic           = var.scale_out_statistic
  scale_out_period              = var.scale_out_period
  scale_out_evaluation_periods  = var.scale_out_evaluation_periods
  scale_out_cooldown            = var.scale_out_cooldown

  scale_in_cpu_threshold       = var.scale_in_cpu_threshold
  scale_in_adjustment          = var.scale_in_adjustment
  scale_in_comparison_operator = var.scale_in_comparison_operator
  scale_in_statistic           = var.scale_in_statistic
  scale_in_period              = var.scale_in_period
  scale_in_evaluation_periods  = var.scale_in_evaluation_periods
  scale_in_cooldown            = var.scale_in_cooldown

  scale_tracking_cpu = var.scale_tracking_cpu

  alb_arn                 = data.aws_ssm_parameter.alb.value
  scale_tracking_requests = var.scale_tracking_requests

  service_discovery_namespace = data.aws_ssm_parameter.service_discovery_namespace.value
}