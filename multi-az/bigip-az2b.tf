resource "aws_network_interface" "vpc-b_aws_subnet_4" {
  subnet_id        = aws_subnet.vpc-b_subnet_4.id
  security_groups = [aws_security_group.vpc-b_allow_all.id]

  source_dest_check = false

  tags = {
    Name = "${var.name-prefix}-${var.project}-vpc-b_subnet_4_interface"
  }
}

resource "aws_network_interface" "vpc-b_aws_subnet_5" {
  subnet_id        = aws_subnet.vpc-b_subnet_5.id
  security_groups = [aws_security_group.vpc-b_allow_all.id]
  source_dest_check = false

  tags = {
    Name = "${var.name-prefix}-${var.project}-vpc-b_subnet_5_interface"
  }
}

resource "aws_network_interface" "vpc-b_aws_subnet_6" {
  subnet_id        = aws_subnet.vpc-b_subnet_6.id
  security_groups = [aws_security_group.vpc-b_allow_all.id]
  source_dest_check = false

  tags = {
    Name = "${var.name-prefix}-${var.project}-vpc-b_subnet_6_interface"
  }
}

resource "aws_instance" "bigip-az2b" {
  ami           = var.ami_bigip
  instance_type = var.instance_type_bigip
  key_name = var.key_name
  user_data = templatefile("bigip-az2b.sh.tpl", {
     bigip_password = var.bigip_password,
     bigip_license = var.bigip_license-az2b,
     bigip_port = var.bigip_port
     subnet_5 = aws_network_interface.vpc-b_aws_subnet_5.private_ip
     subnet_6 = aws_network_interface.vpc-b_aws_subnet_6.private_ip
     web_server = aws_instance.web-server-az2b.private_ip
  })

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.vpc-b_aws_subnet_4.id
  }
  network_interface {
    device_index = 1
    network_interface_id = aws_network_interface.vpc-b_aws_subnet_5.id
  }
  network_interface {
    device_index = 2
    network_interface_id = aws_network_interface.vpc-b_aws_subnet_6.id
  }

  tags = {
    for k, v in merge({
      app_type = "bigip"
      Name = "${var.name-prefix}-${var.project}-az2b-bigip"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_eip_association" "vpc-b_subnet_4" {
  network_interface_id =  aws_network_interface.vpc-b_aws_subnet_4.id
  allocation_id = aws_eip.subnet_4.id

  depends_on = [aws_eip.subnet_4, aws_instance.bigip-az2b]
}

resource "aws_eip_association" "vpc-b_subnet_5" {
  network_interface_id =  aws_network_interface.vpc-b_aws_subnet_5.id
  allocation_id = aws_eip.subnet_5.id

  depends_on = [aws_eip.subnet_5, aws_instance.bigip-az2b]
}

resource "aws_eip_association" "vpc-b_subnet_6" {
  network_interface_id =  aws_network_interface.vpc-b_aws_subnet_6.id
  allocation_id = aws_eip.subnet_6.id

  depends_on = [aws_eip.subnet_6, aws_instance.bigip-az2b]
}
output "bigip_az2b_mgmt_external" {
  value =  aws_eip.subnet_4.public_ip
}
output "bigip_az2b_outside_external" {
  value = aws_eip.subnet_5.public_ip
}
output "bigip_az2b_mgmt_internal" {
  value = aws_network_interface.vpc-b_aws_subnet_4.private_ip
}
output "bigip_az2b_outside_internal" {
  value = aws_network_interface.vpc-b_aws_subnet_5.private_ip
}
output "bigip_az2b_inside_internal" {
  value = aws_network_interface.vpc-b_aws_subnet_6.private_ip
}
