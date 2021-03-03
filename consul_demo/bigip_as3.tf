#provider "bigip" {
#  address = aws_instance.bigip.public_ip
#  username = var.bigip_username
#  password = var.bigip_password
#  port = var.bigip_port
#}
#
#
#data "template_file" "init" {
#  template = file("bigip_consul.tpl")
#  vars = {
#    VIP_ADDRESS = aws_instance.bigip.private_ip
#    CONSUL_SERVER = aws_instance.consul-server.public_ip
#  }
#}
#
#resource "bigip_as3" "exampletask" {
#  as3_json = data.template_file.init.rendered
#
#  depends_on = [ aws_instance.bigip ]
#}
