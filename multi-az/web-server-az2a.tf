resource "aws_instance" "web-server-az2a" {
  ami           = var.ami_fedora_server
  instance_type = var.instance_type_linux_server
  subnet_id = aws_subnet.vpc-a_subnet_3.id
  key_name = var.key_name
  security_groups = [aws_security_group.vpc-a_allow_all.id]
  user_data = templatefile("web-server-az2a.sh.tpl", {
     linux_server_pkgs = var.project
     az2a_default_route = aws_network_interface.vpc-a_aws_subnet_3.private_ip
  })

  tags = {
    for k, v in merge({
      app_type = "web"
      Name = "${var.name-prefix}-${var.project}-az2a-web-server"
    },
    var.default_ec2_tags): k => v
  }
}

output "web_server_az2a_internal" {
  value = aws_instance.web-server-az2a.private_ip
}
output "web_server_az2a_external" {
  value = aws_instance.web-server-az2a.public_ip
}
