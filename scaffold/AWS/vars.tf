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
variable "vpc-a-subnets" {
  type = map
  default = {
    vpc-a_subnet_1 = "10.100.1.0/24"  
    vpc-a_subnet_2 = "10.100.2.0/24"  
    vpc-a_subnet_3 = "10.100.3.0/24"  
    vpc-a_subnet_4 = "10.100.4.0/24"  
  }
}

variable "key_name" {
  default = "svk-keypair-f5"
}
variable "instance_type_linux_server" {
  default = "t2.micro"
}

data "aws_ami" "distro" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Fedora-Cloud-Base-34-1.2*"]
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
  owners = [ "125523088429" ]
}

