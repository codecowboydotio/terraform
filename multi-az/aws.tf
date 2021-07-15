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

resource "aws_subnet" "vpc-a_subnet_5" {
  vpc_id = aws_vpc.vpc-a.id
  cidr_block = var.vpc-a_subnet_5
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = "true"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-a-subnet_5b-tf"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_subnet" "vpc-a_subnet_6" {
  vpc_id = aws_vpc.vpc-a.id
  cidr_block = var.vpc-a_subnet_6
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = "true"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-a-subnet_6b-tf"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_subnet" "vpc-a_subnet_7" {
  vpc_id = aws_vpc.vpc-a.id
  cidr_block = var.vpc-a_subnet_7
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = "true"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-a-subnet_7b-tf"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_subnet" "vpc-a_subnet_8" {
  vpc_id = aws_vpc.vpc-a.id
  cidr_block = var.vpc-a_subnet_8
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = "true"

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-a-subnet_8b-tf"
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
      f5_cloud_failover_label = var.cfe_deployment_name
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_route_table" "vpc-a-servers-route-table-tf" {
  vpc_id = aws_vpc.vpc-a.id

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = aws_network_interface.vpc-a_aws_subnet_3.id
  }
  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-a-aza-servers-rt-tf"
      f5_cloud_failover_label = var.cfe_deployment_name
    },
    var.default_ec2_tags): k => v
  }

  depends_on = [ aws_network_interface.vpc-a_aws_subnet_3 ]
}

resource "aws_route_table" "vpc-a-azb-servers-route-table-tf" {
  vpc_id = aws_vpc.vpc-a.id

  route {
    cidr_block = "0.0.0.0/0"
#######
    network_interface_id = aws_network_interface.vpc-a_aws_subnet_7.id
    #network_interface_id = aws_network_interface.vpc-a_aws_subnet_3.id
  }
  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-a-azb-servers-rt-tf"
      f5_cloud_failover_label = var.cfe_deployment_name
    },
    var.default_ec2_tags): k => v
  }

  depends_on = [ aws_network_interface.vpc-a_aws_subnet_3 ]
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
  route_table_id = aws_route_table.vpc-a-servers-route-table-tf.id
}

resource "aws_route_table_association" "vpc-a_subnet_5" {
  subnet_id = aws_subnet.vpc-a_subnet_5.id
  route_table_id = aws_route_table.vpc-a-route-table-tf.id
}
resource "aws_route_table_association" "vpc-a_subnet_6" {
  subnet_id = aws_subnet.vpc-a_subnet_6.id
  route_table_id = aws_route_table.vpc-a-route-table-tf.id
}
resource "aws_route_table_association" "vpc-a_subnet_7" {
  subnet_id = aws_subnet.vpc-a_subnet_7.id
  route_table_id = aws_route_table.vpc-a-route-table-tf.id
}
resource "aws_route_table_association" "vpc-a_subnet_8" {
  subnet_id = aws_subnet.vpc-a_subnet_8.id
  route_table_id = aws_route_table.vpc-a-azb-servers-route-table-tf.id
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

resource "aws_eip" "subnet_1" {
  vpc = true

  tags = {
    Name = "${var.name-prefix}-${var.project}-eip-subnet_1"
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

resource "aws_eip" "subnet_7" {
  vpc = true

  tags = {
    Name = "${var.name-prefix}-${var.project}-eip-subnet_7"
  }
}

resource "aws_eip" "subnet_8" {
  vpc = true

  tags = {
    Name = "${var.name-prefix}-${var.project}-eip-subnet_8"
  }
}


resource "aws_s3_bucket" "cfe" {
  bucket = "${var.name-prefix}-${var.project}-cfe-bucket"
  acl    = "private"
  force_destroy=true
  lifecycle {
    prevent_destroy = false
  }

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-cfe-bucket"
      f5_cloud_failover_label = var.cfe_deployment_name
    },
    var.default_ec2_tags): k => v
  }
}
