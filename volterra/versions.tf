terraform {
  required_providers {
    volterra = {
      source = "volterraedge/volterra"
    #  version = "0.8.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
    #  version = ">= 1.7.0"
    }
  }
}
