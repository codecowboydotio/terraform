data "template_file" "web-init" {
  template = file("web-server.sh.tpl")
}

resource "aws_instance" "web-server" {
  ami           = var.ami_web_server
  instance_type = var.instance_type_linux_server
  subnet_id = var.subnet_id
  key_name = var.key_name
  user_data = data.template_file.web-init.rendered

  tags = {
    for k, v in merge({
      app_type = "web-server"
      Name = "svk-web-server"
    },
    var.default_ec2_tags): k => v
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.web-server.private_ip} > files/web_internal_ip.txt"
  }
  provisioner "local-exec" {
    command = "echo ${aws_instance.web-server.public_ip} > files/web_external_ip.txt"
  }
}


output "web_server_ip" {
  value = aws_instance.web-server.*.public_ip
}
