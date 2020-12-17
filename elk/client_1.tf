#data "template_file" "client-1-init" {
#  template = file("ansible-server.sh.tpl")
#}

resource "aws_instance" "client_1" {
  ami           = var.ami_ubuntu_server
  instance_type = var.instance_type_linux_server
  subnet_id =  aws_subnet.client1.id
  key_name = var.key_name
#  user_data = data.template_file.client-1-init.rendered

  tags = {
    for k, v in merge({
      app_type = "client_1"
      Name = "svk-client_1"
    },
    var.default_ec2_tags): k => v
  }

  depends_on = [aws_subnet.client1]
}

output "client_1_public_ip" {
  value = aws_instance.client_1.public_ip
}
