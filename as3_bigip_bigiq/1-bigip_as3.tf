# This is an example of using terraform to configure the bigip directly using AS3
#
# Workflow is terraform -> AS3 template -> BIGIP
#
 
#provider "bigip" {
#  address = var.bigip_address
#  username = var.bigip_username
#  password = var.bigip_password
#  port = var.bigip_port
#}
#
#
#data "template_file" "init" {
#  template = file("bigip_consul.tpl")
#  vars = {
#    VIP_ADDRESS = var.bigip_private_address
#    CONSUL_SERVER = var.consul_private_address
#  }
#}
#
#resource "bigip_as3" "exampletask" {
#  as3_json = data.template_file.init.rendered
#}
