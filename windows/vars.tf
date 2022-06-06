variable "aws_region" {
  default = "ap-southeast-2"
}
variable "name-prefix" {
  default = "svk"
}
variable "project" {
  default = "win-test"
}
variable "vpc-a_cidr_block" {
  default = "10.100.0.0/16"
}
variable "vpc-a_subnet_1" {
  default = "10.100.1.0/24"
}
variable "key_name" {
  default = "svk-key"
}
variable "instance_type_linux_server" {
  default = "t2.xlarge"
}
variable "win_username" {
  default = "tester"
}
variable "win_password" {
  default = "Azfg45jb12"
}

data "aws_ami" "distro" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Core-ContainersLatest-*"]
    #values = ["Windows_Server-2012-R2_RTM-English-64Bit-Base-2021.12.15"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  # ami owner
  owners = [ "801119661308" ]
}
