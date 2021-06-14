resource "aws_network_interface" "aws_subnet_1" {
  subnet_id        = aws_subnet.subnet_1.id
  security_groups = [aws_security_group.allow_all.id]

  source_dest_check = false

  tags = {
    Name = "${var.name-prefix}-${var.project}-subnet_1_interface"
  }
}

resource "aws_network_interface" "aws_subnet_2" {
  subnet_id        = aws_subnet.subnet_2.id
  security_groups = [aws_security_group.allow_all.id]
  source_dest_check = false

  tags = {
    Name = "${var.name-prefix}-${var.project}-subnet_2_interface"
  }
}

resource "aws_network_interface" "aws_subnet_3" {
  subnet_id        = aws_subnet.subnet_3.id
  security_groups = [aws_security_group.allow_all.id]
  source_dest_check = false

  tags = {
    Name = "${var.name-prefix}-${var.project}-subnet_3_interface"
  }
}

resource "aws_instance" "bigip" {
  ami           = var.ami_bigip
  instance_type = var.instance_type_bigip
  key_name = var.key_name
  user_data = templatefile("bigip.sh.tpl", {
     bigip_password = var.bigip_password,
     bigip_license = var.bigip_license,
     bigip_port = var.bigip_port
     subnet_2 = aws_network_interface.aws_subnet_2.private_ip
     subnet_3 = aws_network_interface.aws_subnet_3.private_ip
  })

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.aws_subnet_1.id
  }
  network_interface {
    device_index = 1
    network_interface_id = aws_network_interface.aws_subnet_2.id
  }
  network_interface {
    device_index = 2
    network_interface_id = aws_network_interface.aws_subnet_3.id
  }

  tags = {
    for k, v in merge({
      app_type = "bigip"
      Name = "${var.name-prefix}-${var.project}-bigip"
    },
    var.default_ec2_tags): k => v
  }
#
#  provisioner "local-exec" {
#    command = "cp -p files/f5-configure.template files/f5-configure.yml"
#  }
#  provisioner "local-exec" {
#    command = "sed -i s'/10.200.6.x/${aws_network_interface.aws_subnet_outside.private_ip}/g' files/f5-configure.yml"
#  }
#  provisioner "local-exec" {
#    command = "sed -i s'/10.200.7.x/${aws_network_interface.aws_subnet_client_1.private_ip}/g' files/f5-configure.yml"
#  }
#  provisioner "local-exec" {
#    command = "sed -i s'/10.200.8.x/${aws_network_interface.aws_subnet_client_2.private_ip}/g' files/f5-configure.yml"
#  }
#  provisioner "local-exec" {
#    command = "sed -i s'/xxxserverxxx/${aws_eip.mgmt.public_ip}/g' files/f5-configure.yml"
#  }
#  provisioner "local-exec" {
#    command = "sed -i s'/xxxelkpublicipxxx/${aws_instance.elk.private_ip}/g' files/f5-configure.yml"
#  }
#  provisioner "local-exec" {
#    command = "sed -i s'/xxxclient_1_ipxxx/${aws_instance.client_1.private_ip}/g' files/f5-configure.yml"
#  }
#
#  depends_on = [aws_subnet.mgmt, aws_subnet.client1, aws_network_interface.aws_subnet_client_1, aws_network_interface.aws_subnet_client_2]
}
#
resource "aws_eip_association" "subnet_1" {
  network_interface_id =  aws_network_interface.aws_subnet_1.id
  allocation_id = aws_eip.subnet_1.id

  depends_on = [aws_eip.subnet_1, aws_instance.bigip]
}

resource "aws_eip_association" "subnet_2" {
  network_interface_id =  aws_network_interface.aws_subnet_2.id
  allocation_id = aws_eip.subnet_2.id

  depends_on = [aws_eip.subnet_2, aws_instance.bigip]
}

resource "aws_eip_association" "subnet_3" {
  network_interface_id =  aws_network_interface.aws_subnet_3.id
  allocation_id = aws_eip.subnet_3.id

  depends_on = [aws_eip.subnet_3, aws_instance.bigip]
}
#output "bigip_mgmt_outside" {
#  value =  aws_eip.mgmt.public_ip
#}
#output "bigip_outside_external" {
#  value = aws_eip.outside.public_ip
#}
#output "bigip_mgmt_internal" {
#  value = aws_network_interface.aws_subnet_mgmt.private_ip
#}
output "bigip_outside_internal" {
  value = aws_network_interface.aws_subnet_2.private_ip
}
#output "bigip_client_1_internal" {
#  value = aws_network_interface.aws_subnet_client_1.private_ip
#}
#output "bigip_client_2_internal" {
#  value = aws_network_interface.aws_subnet_client_2.private_ip
#}
