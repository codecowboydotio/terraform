variable "ns" { default = "s-vankalken" }
variable "app_name" { default = "svk-demo-app2" }
variable "domain" { default = "sa.f5demos.com" }
variable "servicename" { default = "svk-swapi-api" }
variable "site_selector" { default = [ "ves.io/siteName in (ves-io-wes-sea)" ] }
#variable "site_selector" { default = "ves.io/siteName in (ves-io-ny8-nyc, ves-io-wes-sea)" }
