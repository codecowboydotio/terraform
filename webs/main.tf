provider "aws" {
  profile = "default"
  region  = var.aws_region
}

data "template_file" "web-init" {
  template = "${file("web-server.sh.tpl")}"
  vars = {
    consul_address = var.consul_address
  }
}

resource "aws_instance" "web-server" {
  ami           = var.ami_linux_server
  instance_type = var.instance_type_linux_server
  subnet_id = var.subnet_id
  key_name = var.key_name
  user_data = data.template_file.web-init.rendered
  count=10

  tags = { 
    Name = "svk_web_server"
    Owner = "svk"
    Environment = "Demo"
    SupportTeam = "ANZSE"
    Contact     = "svk@example.com"
  }

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

output "web_server_ip" {
  value = "${aws_instance.web-server.*.public_ip}"
}
