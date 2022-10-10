
resource "kubernetes_deployment" "apps_deploy" {
  count = length(local.app_data.applications)
  metadata {
    name = local.app_data.applications[count.index].name
  }

  spec {
    replicas = local.app_data.applications[count.index].replicas
    selector {
      match_labels = {
        app = "${local.app_data.applications[count.index].name}"
      }
    }

    template {
      metadata {
        labels = {
         app = "${local.app_data.applications[count.index].name}"
        }
      }

      spec {
        container {
          image = local.app_data.applications[count.index].image
          name  = local.app_data.applications[count.index].name
          args = ["${local.app_data.applications[count.index].args[0]}", "${local.app_data.applications[count.index].args[1]}"]
        }
      }
    }
  }
  depends_on = [
    helm_release.nginx_ingress
  ]
}














