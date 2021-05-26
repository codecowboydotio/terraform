#provider "bigip" {
#  address = aws_instance.bigip.public_ip
#  username = var.bigip_username
#  password = var.bigip_password
#  port = var.bigip_port
#}
#
#
##resource "bigip_do"  "do-example" {
##     do_json = file("do-example.json")
##     timeout = 15
##}
#data "template_file" "init" {
#  template = file("bigip_consul.tpl")
#  vars = {
#    VIP_ADDRESS = aws_instance.bigip.private_ip
#    CONSUL_SERVER = aws_instance.consul-server.public_ip
#  }
#}

#resource "bigip_as3" "exampletask" {
#  as3_json = data.template_file.init.rendered
#
#  depends_on = [ aws_instance.bigip ]
#}

#provider "bigip" {
#  address = "54.206.188.177"
#  username = var.bigip_username
#  password = var.bigip_password
#  port = "443"
#}

#data "template_file" "bigiq" {
#  template = file("bigiq_as3.tpl")
#  vars = {
#    VIP_ADDRESS = aws_instance.bigip.private_ip
#    CONSUL_SERVER = aws_instance.consul-server.public_ip
#  }
#}
#resource "bigip_bigiq_as3" "exampletask" {
#  bigiq_address = "54.206.188.177"
#  bigiq_user = "admin"
#  bigiq_password = "admin"
#  as3_json = data.template_file.bigiq.rendered
#
#  depends_on = [ aws_instance.bigip, aws_instance.bigiq ]
#}
