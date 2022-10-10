

resource "kubernetes_service" "app_svc" {
  count = length(local.app_data.applications)
  metadata {
    name = local.app_data.applications[count.index].name
  }
  spec {
    selector = {
      app = "${local.app_data.applications[count.index].name}"
    }
    port {
      port        = 8080
      target_port = local.app_data.applications[count.index].port
    }
    type = "NodePort"
  }
  depends_on = [
    kubernetes_deployment.apps_deploy
  ]
  
}

