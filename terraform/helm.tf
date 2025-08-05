provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", aws_eks_cluster.cluster.name]
    }
  }
}

resource "helm_release" "autoscaler" {
  name             = "cluster-autoscaler"
  repository       = "https://kubernetes.github.io/autoscaler"
  chart            = "cluster-autoscaler"
  version          = var.cluster_autoscaler_version
  namespace        = "cluster-autoscaler"
  create_namespace = true

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "awsRegion"
    value = var.region
  }

  set {
    # Double escaping needed as otherwise . is inteprerted as a nesting
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.cluster_autoscaler_irsa.iam_role_arn
  }

  wait = true

  depends_on = [
    aws_eks_cluster.cluster,
    module.cluster_autoscaler_irsa
  ]
}

resource "helm_release" "kuberay_operator" {
  name             = "kuberay-operator"
  repository       = "https://ray-project.github.io/kuberay-helm"
  chart            = "kuberay-operator"
  namespace        = "ray"
  create_namespace = true
  version          = var.kuberay_operator_version

  wait = true
  depends_on = [
    aws_eks_cluster.cluster
  ]
}

# Kuberay does not provide a prebuilt arm image for the apiserver
# resource "helm_release" "kuberay_apiserver" {
#   name             = "kuberay-apiserver"
#   repository       = "https://ray-project.github.io/kuberay-helm"
#   chart            = "kuberay-apiserver"
#   namespace        = "ray"
#   create_namespace = false  # namespace already created by operator
#   version          = var.kuberay_operator_version
# 
#   wait = false
#   depends_on = [
#     helm_release.kuberay_operator
#   ]
# }

resource "helm_release" "ingress" {
  name             = "ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "support"
  create_namespace = true
  version          = var.nginx_ingress_version

  wait = false  # On private VPC
  depends_on = [
    aws_eks_cluster.cluster
  ]
}
