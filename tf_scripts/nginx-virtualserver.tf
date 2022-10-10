

resource "kubernetes_manifest" "nginx_virtualserver" {
  manifest = {
    "apiVersion" = "k8s.nginx.org/v1"
    "kind"       = "VirtualServer"
    "metadata" = {
      "name"      = "traffic-lb-vserver"
      "namespace" = "default"
    }
    "spec" = {
      "host" = "app.facets.com"
      "upstreams" = [
        {
          "name" = "${local.app_data.applications[0].name}"
          "service" = "${local.app_data.applications[0].name}"
          "port" = 8080
        },
        {
          "name" = "${local.app_data.applications[1].name}"
          "service" = "${local.app_data.applications[1].name}"
          "port" = 8080
        },
         {
          "name" = "${local.app_data.applications[2].name}"
          "service" = "${local.app_data.applications[2].name}"
          "port" = 8080
        }
      ]
      "routes" = [
        {
          "path" = "/"
          "splits" = [
            {
              "weight" = "${local.app_data.applications[0].traffic_weight}"
              "action" = {
                "pass" = "${local.app_data.applications[0].name}"
              }
            },
            {
              "weight" = "${local.app_data.applications[1].traffic_weight}"
              "action" = {
                "pass" = "${local.app_data.applications[1].name}"
              }
            },
            {
              "weight" = "${local.app_data.applications[2].traffic_weight}"
              "action" = {
                "pass" = "${local.app_data.applications[2].name}"
              }
            }
          ]
        }
      ]
    }
  }
  depends_on = [
    kubernetes_service.app_svc
  ]
}
