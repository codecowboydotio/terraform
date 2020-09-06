provider "aws" {
  profile = "default"
  region  = var.aws_region
}

data "template_file" "init" {
  template = file("user_data.sh.tpl")

  vars = {
    bigip_password = var.bigip_password,
    bigip_license  = var.bigip_license
  }
}

resource "aws_instance" "svk" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  key_name = var.key_name
  user_data = data.template_file.init.rendered

  tags = { 
    for k, v in merge(var.default_ec2_tags): 
      k => v 
  }
}

output "public_ip" {
  value = "${aws_instance.svk.*.public_ip}"
}
output "tags" {
  value = "${aws_instance.svk.*.tags}"
}
