resource "aws_instance" "unit-server" {
  ami           = var.ami_fedora_server
  instance_type = var.instance_type
  subnet_id = aws_subnet.subnet_1.id
  key_name = var.key_name
  vpc_security_group_ids = [ aws_security_group.allow_all.id ]
  user_data = templatefile("unit-server.sh.tpl", { 
     linux_server_pkgs = var.linux_server_pkgs
  })

  tags = {
    for k, v in merge({
      app_type = "unit"
      Name = "svk-unit-server"
    },
    var.default_ec2_tags): k => v
  }

}


output "unit_server_ip" {
  value = aws_instance.unit-server.public_ip
}
