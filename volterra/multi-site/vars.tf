variable "ns" { default = "s-vankalken" }
variable "domain" { default = "sa.f5demos.com" }
variable "servicename" { default = "svk-swapi-api7" }
variable "frontend_servicename" { default = "svk-swapi-frontend7" }
variable "manifest_app_name" { default = "svk-swapi-api7" }
variable "frontend_manifest_app_name" { default = "svk-swapi-frontend7" }
variable "site_selector" { default = [ "ves.io/siteName in (ves-io-wes-sea, ves-io-ny8-nyc)" ] }

variable "be-ns" { default = "s-vankalken-be" }
variable "be_site_selector" { default = [ "ves.io/siteName in (ves-io-sg3-sin)"] }

#variable "site_selector" { default = "ves.io/siteName in (ves-io-ny8-nyc, ves-io-wes-sea)" }
#variable "app_name" { default = "svk-demo-app" }
