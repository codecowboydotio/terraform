resource "aws_instance" "web-server-az2b" {
  ami           = var.ami_fedora_server
  instance_type = var.instance_type_linux_server
  subnet_id = aws_subnet.subnet_6.id
  key_name = var.key_name
  security_groups = [aws_security_group.allow_all.id]
  user_data = templatefile("web-server-az2b.sh.tpl", {
     linux_server_pkgs = var.project
  })

  tags = {
    for k, v in merge({
      app_type = "web"
      Name = "${var.name-prefix}-${var.project}-az2b-web-server"
    },
    var.default_ec2_tags): k => v
  }
}

output "web_server_az2b_internal" {
  value = aws_instance.web-server-az2b.private_ip
}
output "web_server_az2b_external" {
  value = aws_instance.web-server-az2b.public_ip
}
