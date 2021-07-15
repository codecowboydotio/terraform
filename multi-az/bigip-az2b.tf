resource "aws_network_interface" "vpc-a_aws_subnet_5" {
  subnet_id        = aws_subnet.vpc-a_subnet_5.id
  security_groups = [aws_security_group.vpc-a_allow_all.id]

  source_dest_check = false

  tags = {
    Name = "${var.name-prefix}-${var.project}-vpca_subnet_5_interface"
  }

  depends_on = [aws_security_group.vpc-a_allow_all]
}

resource "aws_network_interface" "vpc-a_aws_subnet_6" {
  subnet_id        = aws_subnet.vpc-a_subnet_6.id
  security_groups = [aws_security_group.vpc-a_allow_all.id]
  source_dest_check = false
  private_ips = [ "10.100.6.20", "10.100.6.21" ]

  tags = {
    Name = "${var.name-prefix}-${var.project}-vpca_subnet_6_interface"
    f5_cloud_failover_label = var.cfe_deployment_name
    f5_cloud_failover_nic_map = var.cfe_nic_map
  }

  depends_on = [aws_security_group.vpc-a_allow_all]
}


resource "aws_eip" "subnet_6_1" {
  vpc = true
  network_interface = aws_network_interface.vpc-a_aws_subnet_6.id
  associate_with_private_ip = "10.100.6.20"

  tags = {
    Name = "${var.name-prefix}-${var.project}-eip-subnet_6_1"
  }
}

resource "aws_eip" "subnet_6_2" {
  vpc = true
  network_interface = aws_network_interface.vpc-a_aws_subnet_6.id
  associate_with_private_ip = "10.100.6.21"

  tags = {
    Name = "${var.name-prefix}-${var.project}-eip-subnet_6_2"
    f5_cloud_failover_label = var.cfe_deployment_name
    f5_cloud_failover_vips = "10.100.2.21,10.100.6.21"
  }
}


resource "aws_network_interface" "vpc-a_aws_subnet_7" {
  subnet_id        = aws_subnet.vpc-a_subnet_7.id
  security_groups = [aws_security_group.vpc-a_allow_all.id]
  source_dest_check = false

  tags = {
    Name = "${var.name-prefix}-${var.project}-vpca_subnet_7_interface"
  }

  depends_on = [aws_security_group.vpc-a_allow_all]
}

resource "aws_network_interface" "vpc-a_aws_subnet_8" {
  subnet_id        = aws_subnet.vpc-a_subnet_8.id
  security_groups = [aws_security_group.vpc-a_allow_all.id]
  source_dest_check = false

  tags = {
    Name = "${var.name-prefix}-${var.project}-vpca_subnet_8_interface"
  }

  depends_on = [aws_security_group.vpc-a_allow_all]
}

resource "aws_instance" "bigip-az2b" {
  ami           = var.ami_bigip
  instance_type = var.instance_type_bigip
  key_name = var.key_name
  user_data = templatefile("bigip-az2b.sh.tpl", {
     bigip_password = var.bigip_password,
     bigip_license = var.bigip_license-az2b,
     bigip_port = var.bigip_port
     subnet_6 = aws_network_interface.vpc-a_aws_subnet_6.private_ip
     subnet_7 = aws_network_interface.vpc-a_aws_subnet_7.private_ip
     web_server-az2b = aws_instance.web-server-az2a.private_ip

  })

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.vpc-a_aws_subnet_5.id
  }
  network_interface {
    device_index = 1
    network_interface_id = aws_network_interface.vpc-a_aws_subnet_6.id
  }
  network_interface {
    device_index = 2
    network_interface_id = aws_network_interface.vpc-a_aws_subnet_7.id
  }

  tags = {
    for k, v in merge({
      app_type = "bigip"
      Name = "${var.name-prefix}-${var.project}-az2b-bigip"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_eip_association" "subnet_5" {
  network_interface_id =  aws_network_interface.vpc-a_aws_subnet_5.id
  allocation_id = aws_eip.subnet_5.id

  depends_on = [aws_eip.subnet_5, aws_instance.bigip-az2b]
}

resource "aws_eip_association" "subnet_7" {
  network_interface_id =  aws_network_interface.vpc-a_aws_subnet_7.id
  allocation_id = aws_eip.subnet_7.id

  depends_on = [aws_eip.subnet_7, aws_instance.bigip-az2b]
}

output "bigip-az2b_mgmt_external" {
  value =  aws_eip.subnet_5.public_ip
}
output "bigip-az2b_outside_external_1" {
  value = aws_eip.subnet_6_1.public_ip
}
output "bigip-az2b_outside_external_2" {
  value = aws_eip.subnet_6_2.public_ip
}
output "bigip-az2b_mgmt_internal" {
  value = aws_network_interface.vpc-a_aws_subnet_5.private_ip
}
output "bigip-az2b_outside_internal" {
  value = aws_network_interface.vpc-a_aws_subnet_6.private_ip
}
output "bigip-az2b_inside_internal" {
  value = aws_network_interface.vpc-a_aws_subnet_7.private_ip
}
