variable "aws_region" {
  default = "ap-southeast-2"
}
variable "subnet_id" {
  default =  "YOUR AWS SUBNET"
}
variable "key_name" {
  default = "YOUR AWS KEY NAME"
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
  default = "YOURKEY LOCATION"
}
variable "device_id_script_tag" {
  default = "FULL DEVICEID SCRIPT TAG"
}
