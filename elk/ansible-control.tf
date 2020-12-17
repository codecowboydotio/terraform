data "template_file" "ansible-control-init" {
  template = file("ansible-server.sh.tpl")
}

resource "aws_instance" "ansible" {
  ami           = var.ami_ubuntu_server
  instance_type = var.instance_type_linux_server
  subnet_id =  aws_subnet.mgmt.id
  key_name = var.key_name
  user_data = data.template_file.ansible-control-init.rendered

  tags = {
    for k, v in merge({
      app_type = "ansible"
      Name = "svk-ansible"
    },
    var.default_ec2_tags): k => v
  }

  depends_on = [aws_subnet.mgmt]

  provisioner "file" {
    source      = "files/"
    destination = "/tmp"

    connection {
      type     = "ssh"
      user     = var.ssh_user
      private_key = file(var.ssh_key_location)
      host     = self.public_ip
    }
  }

}

output "ansible_control_public_ip" {
  value = aws_instance.ansible.public_ip
}
