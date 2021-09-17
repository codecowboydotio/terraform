data "aws_subnet_ids" "web-servers" {
  vpc_id = aws_vpc.vpc-a.id

  tags = {
    Name = "${var.name-prefix}-${var.project}-vpc-a_subnet_4-tf"
  }
}

resource "aws_instance" "web-server-az2a" {
  ami           = data.aws_ami.distro.id
  instance_type = var.instance_type_linux_server
  // using one function here to lazily convert a set with a single item to a string
  subnet_id = one(data.aws_subnet_ids.web-servers.ids)
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.vpc-a_allow_all.id]
  user_data = templatefile("web-server-az2a.sh.tpl", {
     linux_server_pkgs = var.project
  })

  tags = {
    for k, v in merge({
      app_type = "web"
      Name = "${var.name-prefix}-${var.project}-az2a-web-server"
    },
    var.default_ec2_tags): k => v
  }
}

output "web_server_az2a_internal" {
  value = aws_instance.web-server-az2a.private_ip
}
output "web_server_az2a_external" {
  value = aws_instance.web-server-az2a.public_ip
}
