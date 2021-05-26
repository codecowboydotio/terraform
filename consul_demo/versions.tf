terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    bigip = {
      source = "f5networks/bigip"
      version = "1.8.0"
    }
#    bigiq = {
#      source = "f5networks/bigip"
#    }
    template = {
      source = "hashicorp/template"
    }
  }
  required_version = ">= 0.13"
}
