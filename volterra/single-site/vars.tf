variable "ns" { default = "s-vankalken" }
variable "domain" { default = "sa.f5demos.com" }
variable "servicename" { default = "svk-swapi-api1" }
variable "vehicles_servicename" { default = "svk-swapi-vehicles1" }
variable "starships_servicename" { default = "svk-swapi-starships1" }
variable "people_servicename" { default = "svk-swapi-people1" }
variable "planets_servicename" { default = "svk-swapi-planets1" }
variable "frontend_servicename" { default = "svk-swapi-frontend1" }

variable "manifest_app_name" { default = "svk-swapi-api1" }
variable "frontend_manifest_app_name" { default = "svk-swapi-frontend1" }
variable "vehicles_manifest_app_name" { default = "svk-swapi-vehicles1" }
variable "starships_manifest_app_name" { default = "svk-swapi-starships1" }
variable "people_manifest_app_name" { default = "svk-swapi-people1" }
variable "planets_manifest_app_name" { default = "svk-swapi-planets1" }

variable "site_selector" { default = [ "ves.io/siteName in (ves-io-wes-sea, ves-io-ny8-nyc)" ] }

variable "be-ns" { default = "s-vankalken-be" }
variable "be_site_selector" { default = [ "ves.io/siteName in (ves-io-sg3-sin)"] }

#variable "site_selector" { default = "ves.io/siteName in (ves-io-ny8-nyc, ves-io-wes-sea)" }
#variable "app_name" { default = "svk-demo-app" }
