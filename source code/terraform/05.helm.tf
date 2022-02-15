resource "helm_release" "argocd-helm" {
  name = "argocd-helm"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = true
  namespace        = "argocd"
}

resource "helm_release" "ingress-con-helm" {
  name = "ingress-con-helm"

  repository       = "https://helm.nginx.com/stable"
  chart            = "nginx-ingress"
  create_namespace = true
  namespace        = "nginx-ingress"

  set {
    name  = "controller.service.create"
    value = "false"
  }

}