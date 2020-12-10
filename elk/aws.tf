provider "aws" {
#  profile = "default"
  region  = var.aws_region
}

resource "aws_subnet" "client1" {
  vpc_id     = var.aws_vpc_id
  cidr_block = var.aws_subnet_client_1
  map_public_ip_on_launch = true

  tags = {
    Name = "svk-tf-client-subnet-1"
  }
}

resource "aws_subnet" "client2" {
  vpc_id     = var.aws_vpc_id
  cidr_block = var.aws_subnet_client_2
  map_public_ip_on_launch = true

  tags = {
    Name = "svk-tf-client-subnet-2"
  }
}

resource "aws_subnet" "mgmt" {
  vpc_id     = var.aws_vpc_id
  cidr_block = var.aws_subnet_mgmt
  map_public_ip_on_launch = true

  tags = {
    Name = "svk-tf-mgmt-subnet"
  }
}

resource "aws_subnet" "outside" {
  vpc_id     = var.aws_vpc_id
  cidr_block = var.aws_subnet_outside
  map_public_ip_on_launch = true

  tags = {
    Name = "svk-tf-outside-subnet"
  }
}

output "subnets" {
  value = aws_subnet.outside.*.id
}
