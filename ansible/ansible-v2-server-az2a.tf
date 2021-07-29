resource "aws_instance" "ansible-v2-server-az2a" {
  ami           = var.ami_fedora_server
  instance_type = var.instance_type_linux_server
  subnet_id = aws_subnet.vpc-a_subnet_1.id
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.vpc-a_allow_all.id]
  user_data = templatefile("ansible-v2-server-az2a.sh.tpl", {
     linux_server_pkgs = var.project
     bigip_address = aws_network_interface.vpc-a_aws_subnet_1.private_ip
  })

  tags = {
    for k, v in merge({
      app_type = "ansible-v2"
      Name = "${var.name-prefix}-${var.project}-az2a-ansible-v2-server"
    },
    var.default_ec2_tags): k => v
  }
}

output "ansible-v2_server_az2a_internal" {
  value = aws_instance.ansible-v2-server-az2a.private_ip
}
output "ansible-v2_server_az2a_external" {
  value = aws_instance.ansible-v2-server-az2a.public_ip
}
