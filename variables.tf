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

variable "instance_type" {
  default     = "t3.large"
  description = <<-EOT
  AWS Instance type used for nodes.
  EOT
}

variable "capacity_type" {
  default     = "ON_DEMAND"
  description = <<-EOT
  Whether to use ON_DEMAND or SPOT instances.
  EOT
  
  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.capacity_type)
    error_message = "The capcity_type value must be ON_DEMAND or SPOT."
  }
}

variable "max_instances" {
  default     = 10
  type        = number
  description = <<-EOT
  Maximum number of instances the autoscaler will scale the cluster up to.
  EOT
}

