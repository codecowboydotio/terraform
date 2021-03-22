# This is an example of bigiq to bigiq using AS3.
# The workflow is: BIG-IQ -> AS3 -> BIG-IP
# The main difference of the templatefile here is that the JSON has a "target" host parameter


#provider "bigip" {
#  address = var.bigip_address
#  username = var.bigip_username
#  password = var.bigip_password
#  port = var.bigip_port
#}
#
#
#data "template_file" "bigiq" {
#  template = file("bigiq_as3.tpl")
#  vars = {
#    VIP_ADDRESS = var.bigip_private_address
#    CONSUL_SERVER = var.consul_private_address
#     TARGET_HOST = var.bigip_private_address
#  }
#}
#resource "bigip_bigiq_as3" "exampletask" {
#  bigiq_address = var.bigiq_address
#  bigiq_user = var.bigiq_username
#  bigiq_password = var.bigiq_password
#  as3_json = data.template_file.bigiq.rendered
#}
