variable "aws_region" {
  default = "ap-southeast-2"
}
variable "name-prefix" {
  default = "svk"
}
variable "project" {
  default = "unit"
}
variable "vpc_cidr_block" {
  default = "10.100.0.0/16"
}
variable "vpc_subnet_1" {
  default = "10.100.1.0/24"
}
variable "vpc_subnet_2" {
  default = "10.100.2.0/24"
}
variable "vpc_subnet_3" {
  default = "10.100.3.0/24"
}
variable "vpc_subnet_4" {
  default = "10.100.4.0/24"
}
variable "key_name" {
  default = "svk-keypair-f5"
}
variable "ami_fedora_server" {
#  default = "ami-001ccfbcf4a8e0814"
  default = "ami-0567f647e75c7bc05"
}
variable "instance_type" {
  default = "t2.large"
}
variable "linux_server_pkgs" {
  default = ["foo"]
}
variable "nginx_ssh_user" {
  default = "ubuntu"
}
variable "ssh_key_location" {
  default = "~/aws-keyfile.pem"
}

