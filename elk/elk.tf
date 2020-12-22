data "template_file" "elk-init" {
  template = file("elk-server.sh.tpl")
}

resource "aws_instance" "elk" {
  ami           = var.ami_ubuntu_server
  instance_type = var.instance_type_linux_server
  subnet_id =  aws_subnet.mgmt.id
  key_name = var.key_name
  user_data = data.template_file.elk-init.rendered

  tags = {
    for k, v in merge({
      app_type = "elk"
      Name = "svk-elk"
    },
    var.default_ec2_tags): k => v
  }

  depends_on = [aws_subnet.mgmt]
}

output "elk_public_ip" {
  value = aws_instance.elk.*.public_ip
}
output "elk_private_ip" {
  value = aws_instance.elk.private_ip
}
output "tags" {
  value = aws_instance.elk.*.tags
}
