provider "aws" {
  profile = "default"
  region  = var.aws_region
}

data "template_file" "web-init" {
  template = "${file("nginx-server.sh.tpl")}"
  vars = {
    consul_address = var.consul_address
  }
}

resource "aws_instance" "nginx-server" {
  ami           = var.ami_linux_server
  instance_type = var.instance_type_linux_server
  subnet_id = var.subnet_id
  key_name = var.key_name
  user_data = data.template_file.web-init.rendered
  #instance_initiated_shutdown_behavior = terminate
  count=var.instance_count

  tags = {
    for k, v in merge({
      app_type = "nginx"
    },
    var.default_ec2_tags): k => v
  }


  provisioner "local-exec" {
    command = "sleep 2"
  }

  provisioner "file" {
    source      = "files/"
    destination = "/tmp"

    connection {
      type     = "ssh"
      user     = var.ssh_user
      private_key = file("~/aws-keyfile.pem")
      host     = self.public_ip
    }
  }
}

output "nginx_server_ip" {
  value = "${aws_instance.nginx-server.*.public_ip}"
}
