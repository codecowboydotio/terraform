variable "aws_region" {
  default = "ap-southeast-2"
}
variable "name-prefix" {
  default = "svk"
}
variable "project" {
  default = "scaffold"
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
variable "ami_fedora_server" {
  default = "ami-001ccfbcf4a8e0814"
}
variable "instance_type_linux_server" {
  default = "t2.micro"
}

data "aws_ami" "distro" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Fedora-Cloud-Base-34-20210720.0.x86_64-hvm-*gp2-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # fedora owner
  owners = [ "125523088429" ]
}

