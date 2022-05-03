resource "aws_instance" "kube-server" {
  ami           = data.aws_ami.distro.id
  instance_type = var.instance_type_linux_server
  subnet_id = aws_subnet.vpc-a_subnet_1.id
  key_name = var.key_name
  count = var.vm_count
  vpc_security_group_ids = [ aws_security_group.vpc-a_allow_all.id ]
  user_data = templatefile("kube-server.sh.tpl", { 
     linux_server_pkgs = var.linux_server_pkgs
  })

  tags = {
    for k, v in merge({
      app_type = "kube"
      Name = "${var.name-prefix}-${var.project}-${count.index}"
    },
    var.default_ec2_tags): k => v
  }

}


output "kube_server_ip" {
  value = aws_instance.kube-server.*.public_ip
}
