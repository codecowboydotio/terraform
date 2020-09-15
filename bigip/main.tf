provider "aws" {
  profile = "default"
  region  = var.aws_region
}

resource "aws_instance" "svk" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  key_name = var.key_name
  user_data = templatefile("user_data.sh.tpl", {
     bigip_password = var.bigip_password,
     bigip_license = var.bigip_license
  })


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
