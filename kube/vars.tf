variable "aws_region" {
  default = "ap-southeast-2"
}
variable "name-prefix" {
  default = "svk"
}
variable "project" {
  default = "kube"
}
variable "vm_count" {
  default = 1
}
variable "vpc-a_cidr_block" {
  default = "10.100.0.0/16"
}

variable "vpc-a_subnet_1" {
  default = "10.100.1.0/24"
}
variable "key_name" {
  default = "svk_keypair"
}
variable "instance_type_linux_server" {
  default = "m4.2xlarge"
}
variable "linux_server_pkgs" {
  default = ["foo"]
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
    #values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04*"]
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

  # ubuntu owner
  owners = [ "099720109477" ]
}

data "aws_ami" "windows" {
  most_recent = true

  filter {
    name   = "name"
    #values = ["Windows_Server-2019-English-Full-HyperV-2022.03.09"]
    values = ["Windows_Server-2022-English-Core-ContainersLatest-*"]
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

