provider "kubernetes" {
    config_path = "config"
}

provider "helm" {
  kubernetes {
    config_path = "config"
  }
}

locals {
  app_data     = jsondecode(file("app.json"))
}
