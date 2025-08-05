# Default USGS dev cluster
region = "us-west-2"

cluster_name = "thodson-dev"

aws_tags = {
  "wma:project_id"     = "uncertainty_ts"
  "wma:application_id" = "dev-cluster"
  "wma:contact"        = "thodson@usgs.gov"
}

aws_vpc = {
  default = false
  id = "vpc-0af42fd592a1efc5b"
}

permissions_boundary = "arn:aws:iam::807615458658:policy/csr-Developer-Permissions-Boundary"