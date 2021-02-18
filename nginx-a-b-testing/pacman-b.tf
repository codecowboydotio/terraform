#data "template_file" "pacman-b-init" {
#  template = file("pacman-b.sh.tpl")
#}

resource "aws_instance" "pacman-b" {
  ami           = var.ami_pacman
  instance_type = var.instance_type_linux_server
  subnet_id = var.subnet_id
  key_name = var.key_name
#  user_data = data.template_file.pacman-b-init.rendered
  user_data = templatefile("pacman-b.sh.tpl", {
    device_id_script_tag = var.device_id_script_tag
  })



  tags = {
    for k, v in merge({
      app_type = "pacman-b"
      Name = "svk-pacman-b"
    },
    var.default_ec2_tags): k => v
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


output "pacman-b_ip" {
  value = aws_instance.pacman-b.public_ip
}

