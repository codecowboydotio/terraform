provider "aws" {
  region  = var.aws_region
}

data "aws_vpcs" "default" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_security_groups" "default" {
  filter {
    name = "vpc-id"
    values = data.aws_vpcs.default.ids
  }
}

resource "aws_subnet" "client1" {
  vpc_id     = var.aws_vpc_id
  cidr_block = var.aws_subnet_client_1
  map_public_ip_on_launch = true

  tags = {
    Name = "svk-tf-client-subnet-1"
  }
}

resource "aws_route_table" "client1" {
  vpc_id = var.aws_vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id =  aws_network_interface.aws_subnet_client_1.id
  }
  tags = { 
    Name = "svk-client1-route-table-tf"
  }

  depends_on = [aws_network_interface.aws_subnet_client_1, aws_instance.client_1]
}

resource "aws_route_table_association" "client1" {
  subnet_id = aws_subnet.client1.id
  route_table_id = aws_route_table.client1.id
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

resource "aws_eip" "outside" {
  vpc = true

  tags = {
    Name = "svk-eip-outside-tf"
  }
}

resource "aws_eip" "mgmt" {
  vpc = true

  tags = {
    Name = "svk-eip-mgmt-tf"
  }
}

resource "aws_eip" "client1_mgmt" {
  vpc = true

  tags = {
    Name = "svk-eip-client1-mgmt-tf"
  }
}
