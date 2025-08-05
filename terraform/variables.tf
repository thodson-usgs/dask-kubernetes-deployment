variable "region" {
  type        = string
  description = <<-EOT
  AWS region to perform all our operations in.
  EOT
}

variable "cluster_name" {
  type        = string
  description = <<-EOT
  Name of EKS cluster to create
  EOT
}

variable "aws_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
  (Optional) AWS resource tags.
  EOT
}

variable "permissions_boundary" {
  type        = string
  default     = null
  description = <<-EOT
  (Optional) ARN of the policy that is used to set the permissions boundary for
  the role.
  EOT
}

variable "aws_vpc" {
  type = map(string)
  default = {
    default = true
    id = null
  }
  description = <<-EOT
  (Optional) AWS VPC configuration.
  EOT
}

variable "cluster_autoscaler_version" {
  default     = "9.48.0"
  description = <<-EOT
  Version of cluster autoscaler helm chart to install.
  EOT
}

variable "cert_manager_version" {
  default     = "1.18.2"
  description = <<-EOT
  Version of cert-manager helm chart to install.
  EOT
}

variable "nginx_ingress_version" {
  default     = "4.13.0"
  description = <<-EOT
  Version of the prometheus helm chart to install
  EOT
} 
  
variable "kuberay_operator_version" {
  default     = "1.4.2"
  description = <<-EOT
  Version of KubeRay operator helm chart to install.
  EOT
}

variable "node_groups" {
  type = map(object({
    instance_type = string
    capacity_type = string
    min_size      = number
    max_size      = number
    desired_size  = number
    ami_type      = string
  }))
  default = {
    core = {
      instance_type = "t4g.medium"
      capacity_type = "ON_DEMAND"
      min_size      = 1
      max_size      = 10
      desired_size  = 1
      ami_type      = "BOTTLEROCKET_ARM_64"
    }
    c7i-2xlarge = {
      instance_type = "c7i.2xlarge"
      capacity_type = "ON_DEMAND"
      min_size      = 0
      max_size      = 10
      desired_size  = 0
      ami_type      = "BOTTLEROCKET_x86_64"
    }
    trn1-2xlarge = {
      instance_type = "trn1.2xlarge"
      capacity_type = "ON_DEMAND"
      min_size      = 0
      max_size      = 2
      desired_size  = 0
      ami_type      = "BOTTLEROCKET_x86_64_NVIDIA"
    }
    g6-2xlarge = {
      instance_type = "g6.2xlarge"
      capacity_type = "ON_DEMAND"
      min_size      = 0
      max_size      = 2
      desired_size  = 0
      ami_type      = "BOTTLEROCKET_x86_64_NVIDIA"
    }
  }
  description = <<-EOT
  Map of node group configurations for EKS node groups.
  EOT
}
