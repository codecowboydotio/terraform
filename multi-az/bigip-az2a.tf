resource "aws_network_interface" "vpc-a_aws_subnet_1" {
  subnet_id        = aws_subnet.vpc-a_subnet_1.id
  security_groups = [aws_security_group.vpc-a_allow_all.id]

  source_dest_check = false

  tags = {
    Name = "${var.name-prefix}-${var.project}-vpca_subnet_1_interface"
  }

  depends_on = [aws_security_group.vpc-a_allow_all]
}

resource "aws_network_interface" "vpc-a_aws_subnet_2" {
  subnet_id        = aws_subnet.vpc-a_subnet_2.id
  security_groups = [aws_security_group.vpc-a_allow_all.id]
  source_dest_check = false
  private_ips = [ "10.100.2.20" ]

  tags = {
    Name = "${var.name-prefix}-${var.project}-vpca_subnet_2_interface"
    f5_cloud_failover_label = var.cfe_deployment_name
    f5_cloud_failover_nic_map = var.cfe_nic_map
  }

  depends_on = [aws_security_group.vpc-a_allow_all]
}

resource "aws_eip" "subnet_2_1" {
  vpc = true
  network_interface = aws_network_interface.vpc-a_aws_subnet_2.id
  associate_with_private_ip = "10.100.2.20"

  tags = {
    Name = "${var.name-prefix}-${var.project}-eip-subnet_2_1"
  }
}

#resource "aws_eip" "subnet_2_2" {
#  vpc = true
#  network_interface = aws_network_interface.vpc-a_aws_subnet_2.id
#  associate_with_private_ip = "10.100.2.20"
#
#  tags = {
#    Name = "${var.name-prefix}-${var.project}-eip-subnet_2_2"
#    f5_cloud_failover_label = var.cfe_deployment_name
#    #f5_cloud_failover_vips = "${aws_network_interface.vpc-a_aws_subnet_2.private_ip},${aws_network_interface.vpc-b_aws_subnet_5.private_ip}"
#    f5_cloud_failover_vips = "10.100.2.21,10.100.6.21"
#  }
#}

resource "aws_network_interface" "vpc-a_aws_subnet_3" {
  subnet_id        = aws_subnet.vpc-a_subnet_3.id
  security_groups = [aws_security_group.vpc-a_allow_all.id]
  source_dest_check = false

  tags = {
    Name = "${var.name-prefix}-${var.project}-vpca_subnet_3_interface"
  }

  depends_on = [aws_security_group.vpc-a_allow_all]
}

resource "aws_instance" "bigip-az2a" {
  ami           = var.ami_bigip
  instance_type = var.instance_type_bigip
  key_name = var.key_name
  user_data = templatefile("bigip-az2a.sh.tpl", {
     bigip_password = var.bigip_password,
     bigip_license = var.bigip_license-az2a,
     bigip_port = var.bigip_port
     subnet_2 = aws_network_interface.vpc-a_aws_subnet_2.private_ip
     subnet_3 = aws_network_interface.vpc-a_aws_subnet_3.private_ip
     web_server-az2a = aws_instance.web-server-az2a.private_ip

  })

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.vpc-a_aws_subnet_1.id
  }
  network_interface {
    device_index = 1
    network_interface_id = aws_network_interface.vpc-a_aws_subnet_2.id
  }
  network_interface {
    device_index = 2
    network_interface_id = aws_network_interface.vpc-a_aws_subnet_3.id
  }

  tags = {
    for k, v in merge({
      app_type = "bigip"
      Name = "${var.name-prefix}-${var.project}-az2a-bigip"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_eip_association" "subnet_1" {
  network_interface_id =  aws_network_interface.vpc-a_aws_subnet_1.id
  allocation_id = aws_eip.subnet_1.id

  depends_on = [aws_eip.subnet_1, aws_instance.bigip-az2a]
}

resource "aws_eip_association" "subnet_3" {
  network_interface_id =  aws_network_interface.vpc-a_aws_subnet_3.id
  allocation_id = aws_eip.subnet_3.id

  depends_on = [aws_eip.subnet_3, aws_instance.bigip-az2a]
}
output "bigip-az2a_mgmt_external" {
  value =  aws_eip.subnet_1.public_ip
}
output "bigip-az2a_outside_external_1" {
  value = aws_eip.subnet_2_1.public_ip
}
#output "bigip-az2a_outside_external_2" {
#  value = aws_eip.subnet_2_2.public_ip
#}
output "bigip-az2a_mgmt_internal" {
  value = aws_network_interface.vpc-a_aws_subnet_1.private_ip
}
output "bigip-az2a_outside_internal" {
  value = aws_network_interface.vpc-a_aws_subnet_2.private_ip
}
output "bigip-az2a_inside_internal" {
  value = aws_network_interface.vpc-a_aws_subnet_3.private_ip
}
