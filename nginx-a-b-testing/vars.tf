variable "aws_region" {
  default = "ap-southeast-2"
}
variable "subnet_id" {
  default =  "subnet-00d6dc3b42d57fa0d"
}
variable "key_name" {
  default = "svk-keypair-f5"
}
variable "ami_linux_server" {
  #default = "ami-0f158b0f26f18e619"
  default = "ami-0987943c813a8426b"
}
variable "ami_pacman" {
  default = "ami-001ccfbcf4a8e0814"
}
variable "instance_type_linux_server" {
  default = "t2.micro"
}
variable "instance_count" {
  default = "1"
}
variable "ssh_user" {
  default = "fedora"
}
variable "nginx_ssh_user" {
  default = "ubuntu"
}
variable "ssh_key_location" {
  default = "~/aws-keyfile.pem"
}
variable "device_id_script_tag" {
  default = "<script async defer src=\"https://dip.zeronaught.com/__imp_apg__/js/f5cs-a_aaUBylCrK9-573d9089.js\" id=\"_imp_apg_dip_\"  ></script>"
}
