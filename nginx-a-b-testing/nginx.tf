provider "aws" {
  region  = var.aws_region
}

resource "aws_instance" "nginx-server" {
  ami           = var.ami_linux_server
  instance_type = var.instance_type_linux_server
  subnet_id = var.subnet_id
  key_name = var.key_name
  user_data = templatefile("nginx-server.sh.tpl", {
    server_a = aws_instance.pacman-a.private_ip
    server_b = aws_instance.pacman-b.private_ip
  })

  tags = {
    for k, v in merge({
      app_type = "nginx"
      Name = "svk-nginx-ab"
    },
    var.default_ec2_tags): k => v
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.nginx-server.public_ip} > files/nginx_external_ip.txt"
  }

  provisioner "file" {
    source      = "files/"
    destination = "/tmp"

    connection {
      type     = "ssh"
      user     = var.nginx_ssh_user
      private_key = file(var.ssh_key_location)
      host     = self.public_ip
    }
  }
  depends_on = [aws_instance.pacman-a, aws_instance.pacman-b]
}

output "nginx_server_ip" {
  value = aws_instance.nginx-server.*.public_ip
}
output "acman-a_ip" {
  value = aws_instance.pacman-a.public_ip
}
