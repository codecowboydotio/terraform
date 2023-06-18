variable "aws_region" {
  default = "ap-southeast-2"
}
variable "name-prefix" {
  default = "svk"
}
variable "project" {
  default = "test"
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
  default = "svk_keypair"
}
variable "instance_type_linux_server" {
  default = "t2.xlarge"
}
variable "linux_server_pkgs" {
  default = ["foo"]
}

data "aws_ami" "distro" {
  most_recent = true

  filter {
    name   = "name"
    #values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04*"]
    #values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04*"]
    #values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-lunar-23.04*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  # ubuntu owner
  owners = [ "099720109477" ]
}

