data "template_file" "gitlab-init" {
  template = file("gitlab-server.sh.tpl")
}

resource "aws_instance" "gitlab-server" {
  ami           = var.ami_linux_server
  instance_type = "t2.large"
  #instance_type = var.instance_type_linux_server
  subnet_id = var.subnet_id
  key_name = var.key_name
  user_data = data.template_file.gitlab-init.rendered

  tags = {
    for k, v in merge({
      app_type = "gitlab-server"
      Name = "svk-gitlab"
    },
    var.default_ec2_tags): k => v
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.gitlab-server.private_ip} > files/gitlab_internal_ip.txt"
  }

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


  depends_on = [aws_instance.nginx-server]

}


output "gitlab_server_ip" {
  value = aws_instance.gitlab-server.*.public_ip
}
