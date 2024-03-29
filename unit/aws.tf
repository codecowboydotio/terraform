provider "aws" {
#  profile = "default"
  region  = var.aws_region
}

resource "aws_vpc" "vpc-a" {
  cidr_block       = var.vpc-a_cidr_block
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-a"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_subnet" "vpc-a_subnet_1" {
  vpc_id = aws_vpc.vpc-a.id
  cidr_block = var.vpc-a_subnet_1
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = "true"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-a-subnet_1-tf"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_subnet" "vpc-a_subnet_2" {
  vpc_id = aws_vpc.vpc-a.id
  cidr_block = var.vpc-a_subnet_2
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = "true"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-a-subnet_2-tf"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_subnet" "vpc-a_subnet_3" {
  vpc_id = aws_vpc.vpc-a.id
  cidr_block = var.vpc-a_subnet_3
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = "true"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-a-subnet_3-tf"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_subnet" "vpc-a_subnet_4" {
  vpc_id = aws_vpc.vpc-a.id
  cidr_block = var.vpc-a_subnet_4
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = "true"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-a-subnet_4-tf"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_internet_gateway" "vpc-a_igw" {
  vpc_id = aws_vpc.vpc-a.id

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-a-igw-tf"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_route_table" "vpc-a-route-table-tf" {
  vpc_id = aws_vpc.vpc-a.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-a_igw.id
  }
  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-a-rt-tf"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_route_table_association" "vpc-a_subnet_1" {
  subnet_id = aws_subnet.vpc-a_subnet_1.id
  route_table_id = aws_route_table.vpc-a-route-table-tf.id
}
resource "aws_route_table_association" "vpc-a_subnet_2" {
  subnet_id = aws_subnet.vpc-a_subnet_2.id
  route_table_id = aws_route_table.vpc-a-route-table-tf.id
}
resource "aws_route_table_association" "vpc-a_subnet_3" {
  subnet_id = aws_subnet.vpc-a_subnet_3.id
  route_table_id = aws_route_table.vpc-a-route-table-tf.id
}
resource "aws_route_table_association" "vpc-a_subnet_4" {
  subnet_id = aws_subnet.vpc-a_subnet_4.id
  route_table_id = aws_route_table.vpc-a-route-table-tf.id
}

resource "aws_security_group" "vpc-a_allow_all" {
    vpc_id = aws_vpc.vpc-a.id
    
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
        Name = "${var.name-prefix}-${var.project}-vpc-a-sec-tf"
      },
      var.default_ec2_tags): k => v
    }
}

resource "aws_ec2_transit_gateway" "unit-tgw" {
  description = "${var.name-prefix}-${var.project}-tgw-tf"
  auto_accept_shared_attachments = "enable"
  multicast_support = "enable"
  default_route_table_association = "enable"
  tags = {
    Name = "${var.name-prefix}-${var.project}-tgw-tf"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc1-attachment" {
  subnet_ids         = [aws_subnet.vpc-a_subnet_1.id]
  transit_gateway_id = aws_ec2_transit_gateway.unit-tgw.id
  vpc_id             = aws_vpc.vpc-a.id
  tags = {
    "Name" = "transit-gateway-attachment1"
  }
}

#resource "aws_eip" "subnet_1" {
#  vpc = true
#
#  tags = {
#    Name = "${var.name-prefix}-${var.project}-eip-subnet_1"
#  }
#}
#
#resource "aws_eip" "subnet_3" {
#  vpc = true
#
#  tags = {
#    Name = "${var.name-prefix}-${var.project}-eip-subnet_3"
#  }
#}
#
#resource "aws_eip" "subnet_4" {
#  vpc = true
#
#  tags = {
#    Name = "${var.name-prefix}-${var.project}-eip-subnet_4"
#  }
#}
