resource "helm_release" "dask_operator" {
  name             = "dask-operator"
  repository       = "https://helm.dask.org"
  chart            = "dask-kubernetes-operator"
  namespace        = "dask-operator"
  create_namespace = true
  #version          = var.cert_manager_version

  set {
    # We can manage CRDs from inside Helm itself, no need for a separate kubectl apply
    name  = "installCRDs"
    value = true
  }
  wait = true
  depends_on = [
    aws_eks_cluster.cluster
  ]
}

