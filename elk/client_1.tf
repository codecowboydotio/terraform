resource "aws_network_interface" "aws_subnet_client_1_server" {
  subnet_id        = aws_subnet.client1.id
  security_groups = data.aws_security_groups.default.ids

  tags = {
    Name = "svk-client1-server-tf"
  }
}

resource "aws_instance" "client_1" {
  ami           = var.ami_ubuntu_server
  instance_type = var.instance_type_linux_server
  key_name = var.key_name
  user_data = templatefile("client_1-server.sh.tpl", {
     ip_address = aws_network_interface.aws_subnet_client_1_server.private_ip
     gateway = aws_network_interface.aws_subnet_client_1.private_ip
  })

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.aws_subnet_client_1_server.id
  }

  tags = {
    for k, v in merge({
      app_type = "client_1"
      Name = "svk-client_1"
    },
    var.default_ec2_tags): k => v
  }

  depends_on = [aws_subnet.client1]
}

output "client_1_management_private_ip" {
  value = aws_instance.client_1.private_ip
}
