resource "aws_network_interface" "aws_subnet_client_1" {
  subnet_id        = aws_subnet.client1.id
  security_groups = data.aws_security_groups.default.ids

  tags = {
    Name = var.aws_subnet_client_1_name
  }
}

resource "aws_network_interface" "aws_subnet_client_2" {
  subnet_id        = aws_subnet.client2.id
  security_groups = data.aws_security_groups.default.ids

  tags = {
    Name = var.aws_subnet_client_2_name
  }
}

resource "aws_network_interface" "aws_subnet_mgmt" {
  subnet_id        = aws_subnet.mgmt.id
  security_groups = data.aws_security_groups.default.ids

  tags = {
    Name = var.aws_subnet_mgmt_name
  }
}

resource "aws_network_interface" "aws_subnet_outside" {
  subnet_id        = aws_subnet.outside.id
  security_groups = data.aws_security_groups.default.ids

  tags = {
    Name = var.aws_subnet_outside_name
  }
}

resource "aws_instance" "bigip" {
  ami           = var.ami_bigip
  instance_type = var.instance_type_bigip
  key_name = var.key_name
  user_data = templatefile("bigip.sh.tpl", {
     bigip_password = var.bigip_password,
     bigip_license = var.bigip_license
  })

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.aws_subnet_mgmt.id
  }
  network_interface {
    device_index = 1
    network_interface_id = aws_network_interface.aws_subnet_client_1.id
  }
  network_interface {
    device_index = 2
    network_interface_id = aws_network_interface.aws_subnet_client_2.id
  }
  network_interface {
    device_index = 3
    network_interface_id = aws_network_interface.aws_subnet_outside.id
  }

  tags = {
    for k, v in merge({
      app_type = "bigip"
      Name = "svk-bigip"
    },
    var.default_ec2_tags): k => v
  }

  depends_on = [aws_subnet.mgmt, aws_subnet.client1, aws_network_interface.aws_subnet_client_1, aws_network_interface.aws_subnet_client_2]
}

resource "aws_eip_association" "outside" {
  network_interface_id =  aws_network_interface.aws_subnet_outside.id
  allocation_id = aws_eip.outside.id

  depends_on = [aws_eip.outside, aws_instance.bigip]
}

resource "aws_eip_association" "mgmt" {
  network_interface_id =  aws_network_interface.aws_subnet_mgmt.id
  allocation_id = aws_eip.mgmt.id

  depends_on = [aws_eip.mgmt, aws_instance.bigip]
}

output "bigip_public_ip" {
  value = aws_instance.bigip.*.public_ip
}
output "default_vpc_id" { 
  value = data.aws_vpcs.default.ids
}
output "aws_security_group" {
  value = data.aws_security_groups.default.ids
}
