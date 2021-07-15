variable "aws_region" {
  default = "ap-southeast-2"
}
variable "name-prefix" {
  default = "svk"
}
variable "project" {
  default = "multi-az"
}
variable "vpc-a_cidr_block" {
  default = "10.100.0.0/16"
}
variable "vpc-a_subnet_1" {
  default = "10.100.1.0/24"
}
variable "vpc-a_subnet_2" {
  default = "10.100.2.0/24"
}
variable "vpc-a_subnet_3" {
  default = "10.100.3.0/24"
}
variable "vpc-a_subnet_4" {
  default = "10.100.4.0/24"
}
variable "vpc-a_subnet_5" {
  default = "10.100.5.0/24"
}
variable "vpc-a_subnet_6" {
  default = "10.100.6.0/24"
}
variable "vpc-a_subnet_7" {
  default = "10.100.7.0/24"
}
variable "vpc-a_subnet_8" {
  default = "10.100.8.0/24"
}
variable "key_name" {
  default = "svk-keypair-f5"
}
variable "ami_fedora_server" {
  default = "ami-001ccfbcf4a8e0814"
}
variable "instance_type_linux_server" {
  default = "t2.micro"
}
variable "bigip_license-az2a" {
  default = "RBYVS-NRRSG-OIEKE-NUJFW-BUXJLTK"
}
variable "bigip_license-az2b" {
  default = "BUNNG-ZNADA-IQMEX-EMMRX-RAWOTWJ"
}
variable "bigip_port" {
  default = "443"
}
variable "bigip_password" {
  default = "password"
}

variable "ami_bigip" {
  default = "ami-012acc5cdab881a3b"
}
variable "instance_type_bigip" {
  default = "m4.2xlarge"
}
variable "cfe_deployment_name" {
  default = "mydeployment"
}
variable "cfe_nic_map" {
  default = "external"
}
