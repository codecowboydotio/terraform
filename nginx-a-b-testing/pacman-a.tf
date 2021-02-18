#data "template_file" "pacman-a-init" {
#  template = file("pacman-a.sh.tpl")
#}

resource "aws_instance" "pacman-a" {
  ami           = var.ami_pacman
  instance_type = var.instance_type_linux_server
  subnet_id = var.subnet_id
  key_name = var.key_name
#  user_data = data.template_file.pacman-a-init.rendered
  user_data = templatefile("pacman-a.sh.tpl", {
    device_id_script_tag = var.device_id_script_tag
  })

  tags = {
    for k, v in merge({
      app_type = "pacman-a"
      Name = "svk-pacman-a"
    },
    var.default_ec2_tags): k => v
  }
}


output "pacman-a_ip" {
  value = aws_instance.pacman-a.public_ip
}

