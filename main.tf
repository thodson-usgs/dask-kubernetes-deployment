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

# Check if any subnet is public (has route to IGW)
data "aws_route_tables" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_route_table" "default" {
  count           = length(data.aws_route_tables.default.ids)
  route_table_id  = data.aws_route_tables.default.ids[count.index]
}

locals {
  # Check if any route table has a route to an internet gateway (0.0.0.0/0)
  has_public_route = anytrue([
    for rt in data.aws_route_table.default : 
    anytrue([
      for route in rt.routes : 
      route.cidr_block == "0.0.0.0/0" && route.gateway_id != null && startswith(route.gateway_id, "igw-")
    ])
  ])
}

