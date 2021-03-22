provider "aws" {
  profile = "default"
  region  = var.aws_region
}

resource "aws_instance" "bigip" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  key_name = var.key_name
  user_data = templatefile("user_data.sh.tpl", { 
     bigip_password = var.bigip_password, 
     bigip_license = var.bigip_license 
  })

  tags = {
    for k, v in merge({
      app_type = "bigip"
      Name = "svk-bigip"
    },
    var.default_ec2_tags): k => v
  }
}


resource "aws_instance" "consul-server" {
  ami           = var.ami_linux_server
  instance_type = var.instance_type_linux_server
  subnet_id = var.subnet_id
  key_name = var.key_name
  user_data = templatefile("consul-server.sh.tpl", { 
     linux_server_pkgs = var.linux_server_pkgs
  })

  tags = {
    for k, v in merge({
      app_type = "consul"
      Name = "svk-consul-server"
    },
    var.default_ec2_tags): k => v
  }
}


data "template_file" "web-init" {
  template = file("web-server.sh.tpl")
  vars = {
    consul_address = aws_instance.consul-server.private_ip
    vsip = aws_instance.bigip.private_ip
  }
  depends_on = [aws_instance.consul-server]
}

resource "aws_instance" "web-server" {
  ami           = var.ami_linux_server
  instance_type = var.instance_type_linux_server
  subnet_id = var.subnet_id
  key_name = var.key_name
  user_data = data.template_file.web-init.rendered
  count = var.webserver_count

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "svk-web-server-${count.index}"
    },
    var.default_ec2_tags): k => v
  }

  depends_on = [aws_instance.consul-server]
}

output "consul_server_ip" {
  value = aws_instance.consul-server.public_ip
}
output "web_server_ip" {
  value = aws_instance.web-server.*.public_ip
}
output "bigip_ip" {
  value = aws_instance.bigip.public_ip
}
