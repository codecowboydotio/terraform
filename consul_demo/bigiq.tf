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

resource "aws_eip" "bigiq_mgmt" {
  vpc = true

  tags = {
    Name = "svk-eip-mgmt-tf"
  }
}

resource "aws_network_interface" "bigiq_net_interface_1" {
  subnet_id        = "subnet-00d6dc3b42d57fa0d"
  security_groups = data.aws_security_groups.default.ids

  tags = {
    Name = "svk-bigiq-1"
  }
}
resource "aws_network_interface" "bigiq_net_interface_2" {
  subnet_id        = "subnet-00d6dc3b42d57fa0d"
  security_groups = data.aws_security_groups.default.ids

  tags = {
    Name = "svk-bigiq-2"
  }
}


resource "aws_instance" "bigiq" {
  ami = "ami-00e7f6524a5382b64"
  # v7 ami = "ami-06d3f0e8654855682"
  instance_type = "m4.2xlarge"
#  subnet_id = var.subnet_id
  key_name = var.key_name
  count = var.bigiq_count
#  user_data = templatefile("user_data_bigiq.sh.tpl", {
#     bigip_password = var.bigip_password,
#     bigiq_license = var.bigiq_license
#  })

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.bigiq_net_interface_1.id
  }
  network_interface {
    device_index = 1
    network_interface_id = aws_network_interface.bigiq_net_interface_2.id
  }

  tags = {
    for k, v in merge({
      app_type = "bigiq"
      Name = "svk-bigiq"
    },
    var.default_ec2_tags): k => v
  }

  depends_on = [aws_network_interface.bigiq_net_interface_1, aws_network_interface.bigiq_net_interface_2, aws_eip.bigiq_mgmt]
}

resource "aws_eip_association" "bigiq_mgmt" {
  network_interface_id =  aws_network_interface.bigiq_net_interface_1.id
  allocation_id = aws_eip.bigiq_mgmt.id

  depends_on = [aws_eip.bigiq_mgmt, aws_instance.bigiq]
}

output "bigiq_ip" {
  value = aws_eip.bigiq_mgmt.public_ip
}
