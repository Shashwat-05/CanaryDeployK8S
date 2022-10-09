locals {
  app_data     = jsondecode(file("app.json"))
}

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
}

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
  }
}


resource "kubernetes_ingress_v1" "normal_ingress" {
  
  metadata {
    name = "normal-ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      host = "facets.app"
      http {
        path {
          backend {
            service {
              name = "boom"
              port {
                number = 8080
              }
            }
          }
          path = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "canary_ingress" {
  count = length(local.app_data.applications) - 1
  metadata {
    name = "canary-ingress-${local.app_data.applications[count.index].name}"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/canary" = "true"
      "nginx.ingress.kubernetes.io/canary-weight" = "${local.app_data.applications[count.index].traffic_weight}"
    }
  }

  spec {
    rule {
      host = "facets.app"
      http {
        path {
          backend {
            service {
              name = "${local.app_data.applications[count.index].name}"
              port {
                number = 8080
              }
            }
          }
          path = "/"
          path_type = "ImplementationSpecific"
        }
      }
    }
  }
}















