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

# This ECR "registry_id" number refers to the AWS account ID for us-west-2 region
# if you are using a different region, make sure to change it, you can get the account from the link below
# https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/docker-custom-images-tag.html
data "aws_ecr_authorization_token" "token" {
  registry_id = "895885662937"
}

data "aws_availability_zones" "available" {}

locals {
  name   = basename(path.cwd)
  #region = "us-west-2"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/aws-ia/terraform-aws-eks-data-addons"
  }
}

module "doeks_data_addons" {
  source            = "../"
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_dask_operator              = true
  #enable_airflow                   = true
  #enable_aws_efa_k8s_device_plugin = true
  #enable_aws_neuron_device_plugin  = true
  #enable_emr_spark_operator        = true
  #enable_flink_operator            = true
  #enable_jupyterhub                = true
  #enable_kubecost                  = true
  #enable_nvidia_gpu_operator       = true
  #enable_kuberay_operator          = true
  #enable_spark_history_server      = true
  #emr_spark_operator_helm_config = {
  #  repository_username = data.aws_ecr_authorization_token.token.user_name
  #  repository_password = data.aws_ecr_authorization_token.token.password
  #}

  #enable_spark_operator = true
  ## With custom values
  #spark_operator_helm_config = {
  #  values = [templatefile("${path.module}/helm-values/spark-operator-values.yaml", {})]
  #}
  #enable_strimzi_kafka_operator = true
  #enable_yunikorn               = true
}

## checkov:skip=CKV_TF_1
##tfsec:ignore:aws-eks-enable-control-plane-logging
#module "eks" {
#  source  = "terraform-aws-modules/eks/aws"
#  version = "~> 19.13"
#
#  cluster_name                   = var.cluster_name
#  cluster_version                = "1.26"
#  cluster_endpoint_public_access = true
#
#  vpc_id     = module.vpc.vpc_id
#  subnet_ids = module.vpc.private_subnets
#
#  manage_aws_auth_configmap = true
#
#  eks_managed_node_groups = {
#    initial = {
#      instance_types = [var.instance_type]
#
#      min_size     = 0
#      max_size     = 10
#      desired_size = 0
#    }
#  }
#
#  tags = local.tags
#}
#
## checkov:skip=CKV_TF_1
#module "vpc" {
#  source  = "terraform-aws-modules/vpc/aws"
#  version = "~> 5.0"
#
#  name = local.name
#  cidr = local.vpc_cidr
#
#  azs             = local.azs
#  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
#  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]
#
#  enable_nat_gateway = true
#  single_nat_gateway = true
#
#  public_subnet_tags = {
#    "kubernetes.io/role/elb" = 1
#  }
#
#  private_subnet_tags = {
#    "kubernetes.io/role/internal-elb" = 1
#  }
#
#  tags = local.tags
#}
#