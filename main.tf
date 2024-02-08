provider "aws" {
  region = var.region
  default_tags { tags = var.aws_tags }
}

data "aws_vpc" "default" {
  default = var.aws_vpc.default
  id      = var.aws_vpc.id
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

