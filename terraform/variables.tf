variable "region" {
  type        = string
  description = "Região da AWS onde os recursos serão provisionados."
}

variable "cluster_name" {
  type        = string
  description = "Nome do cluster ECS que hospedará o serviço."
}

variable "service_name" {
  type        = string
  description = "Nome do serviço que será usado dentro do cluster."
}

variable "service_port" {
  type        = number
  description = "Porta TCP na qual o serviço aceitará tráfego."
}

variable "service_cpu" {
  type        = number
  description = "Quantidade de CPU reservada para o serviço, em unidades definidas pela AWS."
}

variable "service_memory" {
  type        = number
  description = "Quantidade de memória reservada para o serviço, em megabytes."
}

variable "service_healthcheck" {
  type        = map(any)
  description = "Configurações do health check para o serviço, como caminho e protocolo."
}

variable "service_launch_type" {
  type = list(object({
    capacity_provider = string
    weight            = number
  }))
}


variable "container_image" {}

variable "service_hosts" {
  type        = list(string)
  description = "Lista de endereços ou nomes de host atribuídos ao serviço para balanceamento de carga ou exposição."
}

variable "service_task_count" {
  type        = number
  description = "Número de tarefas que o serviço deve manter em execução simultaneamente."
}

variable "ssm_vpc_id" {
  type        = string
  description = "ID do VPC armazenado no AWS Systems Manager (SSM) onde o serviço será implantado."
}

variable "ssm_listener" {
  type        = string
  description = "ARN do listener de um Application Load Balancer (ALB), armazenado no AWS SSM, que será usado pelo serviço."
}

variable "ssm_private_subnet_1" {
  type        = string
  description = "ID da primeira subnet privada, armazenado no AWS SSM, onde o serviço será implantado."
}

variable "ssm_private_subnet_2" {
  type        = string
  description = "ID da segunda subnet privada, armazenado no AWS SSM, para implantação do serviço."
}

variable "ssm_private_subnet_3" {
  type        = string
  description = "ID da terceira subnet privada, armazenado no AWS SSM, usada para implantação do serviço."
}

variable "ssm_alb" {
  type        = string
  description = ""
}

variable "environment_variables" {
  type        = list(map(string))
  description = "Lista de variáveis de ambiente que serão passadas às tarefas do serviço."
}

variable "capabilities" {
  type        = list(string)
  description = "Lista de capacidades especiais necessárias para o serviço, como 'SYS_ADMIN' para determinados privilégios de sistema."
}

variable "scale_type" {}

variable "task_minimum" {}

variable "task_maximum" {}

### Autoscaling de CPU

variable "scale_out_cpu_threshold" {}

variable "scale_out_adjustment" {}

variable "scale_out_comparison_operator" {}

variable "scale_out_statistic" {}

variable "scale_out_period" {}

variable "scale_out_evaluation_periods" {}

variable "scale_out_cooldown" {}

variable "scale_in_cpu_threshold" {}

variable "scale_in_adjustment" {}

variable "scale_in_comparison_operator" {}

variable "scale_in_statistic" {}

variable "scale_in_period" {}

variable "scale_in_evaluation_periods" {}

variable "scale_in_cooldown" {}

### Tracking CPU
variable "scale_tracking_cpu" {}


### Tracking Requests
variable "scale_tracking_requests" {}

### Service Discovery

variable "ssm_service_discovery_namespace" {}