variable "aws_region" {
  default = "ap-southeast-2"
}
variable "subnet_id" {
  default =  "subnet-00d6dc3b42d57fa0d"
}
variable "key_name" {
  default = "svk-keypair-f5"
}
variable "ami" {
  default = "ami-012acc5cdab881a3b"
}
variable "instance_type" {
  default = "m4.2xlarge"
}
variable "bigip_username" {
  default = "admin"
}
variable "bigip_password" {
  default = "admin"
}
variable "bigip_port" {
  default = "8443"
}
variable "bigip_license" {
  default = "NINQO-YUHJJ-TNDUH-TJBMB-DUJQAZN"
}
variable "bigiq_license" {
  default = "VBQQV-BGDTPF-ELN-WPKQYFZ-ROSJYUS"
}
variable "ami_linux_server" {
  default = "ami-001ccfbcf4a8e0814"
}
variable "instance_type_linux_server" {
  default = "t2.micro"
}
variable "linux_server_pkgs" {
  default = ["httpd", "net-tools", "unzip"]
}
variable "webserver_count" {
  default = 4
}
variable "vpc_name" {
  default = "svk-vpc"
}

variable "bigiq_count" {
  default = 1
}
