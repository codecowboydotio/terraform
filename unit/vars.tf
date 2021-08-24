variable "aws_region" {
  default = "ap-southeast-2"
}
variable "name-prefix" {
  default = "svk"
}
variable "project" {
  default = "unit"
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
variable "key_name" {
  default = "svk-keypair-f5"
}
variable "instance_type_linux_server" {
  default = "t2.micro"
}
variable "linux_server_pkgs" {
  default = ["foo"]
}

data "aws_ami" "distro" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  # fedora owner
  owners = [ "099720109477" ]
}

