resource "aws_instance" "unit-server" {
  ami           = data.aws_ami.distro.id
  instance_type = var.instance_type_linux_server
  subnet_id = aws_subnet.vpc-a_subnet_1.id
  key_name = var.key_name
  count = 1
  vpc_security_group_ids = [ aws_security_group.vpc-a_allow_all.id ]
  user_data = templatefile("unit-server.sh.tpl", { 
     linux_server_pkgs = var.linux_server_pkgs
  })

  tags = {
    for k, v in merge({
      app_type = "unit"
      Name = "${var.name-prefix}-${var.project}-server"
    },
    var.default_ec2_tags): k => v
  }

}


output "unit_server_ip" {
  value = aws_instance.unit-server.*.public_ip
}
