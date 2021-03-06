provider "aws" {
  profile = "default"
  region  = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.vpc_subnet_1
  map_public_ip_on_launch = "true"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-subnet_1-tf"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.vpc_subnet_2
  map_public_ip_on_launch = "true"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-subnet_2-tf"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_subnet" "subnet_3" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.vpc_subnet_3
  map_public_ip_on_launch = "true"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-subnet_3-tf"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_subnet" "subnet_4" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.vpc_subnet_4
  map_public_ip_on_launch = "true"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-subnet_4-tf"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-igw-tf"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_route_table" "route-table-tf" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-rt-tf"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_route_table_association" "subnet_1" {
  subnet_id = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.route-table-tf.id
}
resource "aws_route_table_association" "subnet_2" {
  subnet_id = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.route-table-tf.id
}
resource "aws_route_table_association" "subnet_3" {
  subnet_id = aws_subnet.subnet_3.id
  route_table_id = aws_route_table.route-table-tf.id
}
resource "aws_route_table_association" "subnet_4" {
  subnet_id = aws_subnet.subnet_4.id
  route_table_id = aws_route_table.route-table-tf.id
}

resource "aws_security_group" "allow_all" {
    vpc_id = aws_vpc.main.id
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }    
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"        
        cidr_blocks = ["0.0.0.0/0"]
    }    
    tags = {
      for k, v in merge({
        app_type = "production"
        Name = "${var.name-prefix}-${var.project}-sec-tf"
      },
      var.default_ec2_tags): k => v
    }
}
