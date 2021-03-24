# This is an example of bigiq to bigiq using AS3.
# The workflow is: BIG-IQ -> AS3 -> BIG-IP
# The main difference of the templatefile here is that the JSON has a "target" host parameter

# We are also using DO to rediscover and re-import configuration changes on the BIG-IP into the BIG-IQ. 
# The reason for doing this is so that anyone who comes along to use the GUI can see the latest changes without needing to re-import.
# This is a "niceness" example of using automation and co-existing with non automated folk.


#provider "bigip" {
#  address = var.bigiq_address
#  username = var.bigiq_username
#  password = var.bigiq_password
#  port = var.bigiq_port
#}
#
#
#data "template_file" "bigiq" {
#  template = file("bigiq_as3.tpl")
#  vars = {
#    VIP_ADDRESS = var.bigip_private_address
#    CONSUL_SERVER = var.consul_private_address
#    TARGET_HOST = var.bigip_private_address
#  }
#}
#resource "bigip_bigiq_as3" "task-3" {
#  bigiq_address = var.bigiq_address
#  bigiq_user = var.bigiq_username
#  bigiq_password = var.bigiq_password
#  as3_json = data.template_file.bigiq.rendered
#}
#
#data "template_file" "do_bigiq" {
#  template = file("do-example.tpl")
#  vars = {
#    TARGET_HOST = var.bigip_private_address
#  }
#}
#resource "bigip_do"  "do-example-3" {
#  do_json = data.template_file.do_bigiq.rendered
#  timeout = 5
#
#  depends_on = [ bigip_bigiq_as3.task-3 ]
#}
#
