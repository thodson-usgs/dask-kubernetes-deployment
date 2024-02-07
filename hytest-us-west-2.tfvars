# Default USGS pangeo-forge bakery
region = "us-west-2"

cluster_name = "hytest-dask"

aws_tags = {
  "wma:project_id"     = "hytest"
  "wma:application_id" = "pangeo_forge_runner"
  "wma:contact"        = "thodson@usgs.gov"
}

aws_vpc = {
  default = false
  id = "vpc-0af42fd592a1efc5b"
}

permissions_boundary = "arn:aws:iam::807615458658:policy/csr-Developer-Permissions-Boundary"

max_instances = 10

