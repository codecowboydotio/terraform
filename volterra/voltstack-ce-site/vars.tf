variable "aws_key_name" { default = "svk-aws-keys" }
variable "aws_region" { default = "ap-southeast-2" }
variable "aws_instance_type" { default = "t3.2xlarge" }
variable "aws_vpc_name" { default = "svk-volterra" }
variable "aws_vpc_subnet" { default = "10.100.0.0/16" }
variable "aws_az1_subnet" { default = "10.100.1.0/24" }

variable "site_name" { default = "svk-tf" }

variable "ns" { default = "s-vankalken" }
variable "domain_host" { default = "svk-unit-demo" }
variable "domain" { default = "sa.f5demos.com" }
variable "servicename" { default = "svk-unit" }
variable "unit_config_port" { default = "8888" }

#variable "manifest_app_name" { default = "svk-swapi-api" }
#variable "loadgen_manifest_app_name" { default = "svk-swapi-loadgen" }

variable "site_selector" { default = [ "ves.io/siteName in (ves-io-sg3-sin)" ] }

variable "origins" {
  type = map
  default = {
    unit-config-origin = "8888"
    unit-git-origin = "8080"
    unit-app-origin = "8181"
  }
}

variable "tcp_lb" {
  type = map
  default = {
    unit-config-origin = "8888"
    unit-git-origin = "8080"
  }
}
