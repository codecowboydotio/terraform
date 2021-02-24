terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    bigip = {
      source = "f5networks/bigip"
    }
    template = {
      source = "hashicorp/template"
    }
  }
  required_version = ">= 0.13"
}
