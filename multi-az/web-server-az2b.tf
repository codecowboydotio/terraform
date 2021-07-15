resource "aws_instance" "web-server-az2b" {
  ami           = var.ami_fedora_server
  instance_type = var.instance_type_linux_server
  subnet_id = aws_subnet.vpc-a_subnet_8.id
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.vpc-a_allow_all.id]
  user_data = templatefile("web-server-az2b.sh.tpl", {
     linux_server_pkgs = var.project
     az2b_default_route = aws_network_interface.vpc-a_aws_subnet_7.private_ip
  })

  tags = {
    for k, v in merge({
      app_type = "web"
      Name = "${var.name-prefix}-${var.project}-az2b-web-server"
    },
    var.default_ec2_tags): k => v
  }

#  depends_on = [ aws_instance.bigip-az2b ]
}

output "web_server_az2b_internal" {
  value = aws_instance.web-server-az2b.private_ip
}
output "web_server_az2b_external" {
  value = aws_instance.web-server-az2b.public_ip
}
