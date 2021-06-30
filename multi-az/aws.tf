provider "aws" {
  profile = "default"
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

resource "aws_vpc" "vpc-b" {
  cidr_block       = var.vpc-b_cidr_block
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-b"
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

resource "aws_subnet" "vpc-b_subnet_4" {
  vpc_id = aws_vpc.vpc-b.id
  cidr_block = var.vpc-b_vpc_subnet_4
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = "true"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-b-subnet_4-tf"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_subnet" "vpc-b_subnet_5" {
  vpc_id = aws_vpc.vpc-b.id
  cidr_block = var.vpc-b_vpc_subnet_5
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = "true"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-b-subnet_5-tf"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_subnet" "vpc-b_subnet_6" {
  vpc_id = aws_vpc.vpc-b.id
  cidr_block = var.vpc-b_vpc_subnet_6
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = "true"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-b-subnet_6-tf"
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

resource "aws_internet_gateway" "vpc-b_igw" {
  vpc_id = aws_vpc.vpc-b.id

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-b-igw-tf"
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

  depends_on = [ aws_ec2_transit_gateway_vpc_attachment.vpc-a, aws_ec2_transit_gateway.tg ]
}

resource "aws_route" "vpc-a-additional-route" {
  route_table_id = aws_route_table.vpc-a-route-table-tf.id
  destination_cidr_block = "10.200.0.0/16"
  transit_gateway_id = aws_ec2_transit_gateway.tg.id

  depends_on = [ aws_ec2_transit_gateway.tg, aws_route_table.vpc-a-route-table-tf ]
}

resource "aws_route_table" "vpc-b-route-table-tf" {
  vpc_id = aws_vpc.vpc-b.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-b_igw.id
  }
  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-b-rt-tf"
    },
    var.default_ec2_tags): k => v
  }

  depends_on = [ aws_ec2_transit_gateway_vpc_attachment.vpc-b, aws_ec2_transit_gateway.tg ]
}

resource "aws_route" "vpc-b-additional-route" {
  route_table_id = aws_route_table.vpc-b-route-table-tf.id
  destination_cidr_block = "10.100.0.0/16"
  transit_gateway_id = aws_ec2_transit_gateway.tg.id

  depends_on = [ aws_ec2_transit_gateway.tg, aws_route_table.vpc-b-route-table-tf ]
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
resource "aws_route_table_association" "vpc-b_subnet_4" {
  subnet_id = aws_subnet.vpc-b_subnet_4.id
  route_table_id = aws_route_table.vpc-b-route-table-tf.id
}
resource "aws_route_table_association" "vpc-b_subnet_5" {
  subnet_id = aws_subnet.vpc-b_subnet_5.id
  route_table_id = aws_route_table.vpc-b-route-table-tf.id
}
resource "aws_route_table_association" "vpc-b_subnet_6" {
  subnet_id = aws_subnet.vpc-b_subnet_6.id
  route_table_id = aws_route_table.vpc-b-route-table-tf.id
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

resource "aws_security_group" "vpc-b_allow_all" {
    vpc_id = aws_vpc.vpc-b.id
    
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
        Name = "${var.name-prefix}-${var.project}-vpc-b-sec-tf"
      },
      var.default_ec2_tags): k => v
    }
}

resource "aws_eip" "subnet_1" {
  vpc = true

  tags = {
    Name = "${var.name-prefix}-${var.project}-eip-subnet_1"
  }
}

resource "aws_eip" "subnet_2" {
  vpc = true

  tags = {
    Name = "${var.name-prefix}-${var.project}-eip-subnet_2"
  }
}

resource "aws_eip" "subnet_3" {
  vpc = true

  tags = {
    Name = "${var.name-prefix}-${var.project}-eip-subnet_3"
  }
}

resource "aws_eip" "subnet_4" {
  vpc = true

  tags = {
    Name = "${var.name-prefix}-${var.project}-eip-subnet_4"
  }
}

resource "aws_eip" "subnet_5" {
  vpc = true

  tags = {
    Name = "${var.name-prefix}-${var.project}-eip-subnet_5"
  }
}

resource "aws_eip" "subnet_6" {
  vpc = true

  tags = {
    Name = "${var.name-prefix}-${var.project}-eip-subnet_6"
  }
}


# Transit gateway
resource "aws_ec2_transit_gateway" "tg" {
  description = "${var.name-prefix}-${var.project}-tg"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-tg"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc-a" {
  subnet_ids         = [aws_subnet.vpc-a_subnet_3.id]
  transit_gateway_id = aws_ec2_transit_gateway.tg.id
  appliance_mode_support = "enable"
  vpc_id             = aws_vpc.vpc-a.id

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-a-tg-subnet_3_attachment"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc-b" {
  subnet_ids         = [aws_subnet.vpc-b_subnet_6.id]
  transit_gateway_id = aws_ec2_transit_gateway.tg.id
  appliance_mode_support = "enable"
  vpc_id             = aws_vpc.vpc-b.id

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-b-tg-subnet_6_attachment"
    },
    var.default_ec2_tags): k => v
  }
}

data "aws_ec2_transit_gateway" "tg" {
  id = aws_ec2_transit_gateway.tg.id
}
