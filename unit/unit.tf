data "aws_subnet_ids" "unit-servers" {
  vpc_id = aws_vpc.vpc-a.id

  tags = {
    Name = "${var.name-prefix}-${var.project}-vpc-a-subnet_4-tf"
  }
}


resource "aws_instance" "unit-server" {
  ami           = data.aws_ami.distro.id
  instance_type = var.instance_type_linux_server
  // using one function here to lazily convert a set with a single item to a string
  subnet_id = one(data.aws_subnet_ids.unit-servers.ids)
  key_name = var.key_name
  vpc_security_group_ids = [ aws_security_group.vpc-a_allow_all.id ]
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
