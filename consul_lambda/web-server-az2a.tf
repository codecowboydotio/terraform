data "template_file" "web-init" {
  template = file("web-server-az2a.sh.tpl")
  vars = {
    consul_address = aws_instance.consul-server-az2a.private_ip
  }
  depends_on = [aws_instance.consul-server-az2a]
}


resource "aws_instance" "web-server-az2a" {
  ami           = data.aws_ami.distro.id
  instance_type = var.instance_type_linux_server
  subnet_id = aws_subnet.vpc-a_subnet_1.id
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.vpc-a_allow_all.id]
  user_data = data.template_file.web-init.rendered

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
output "consul_address" {
  value = aws_instance.consul-server-az2a.private_ip
}
