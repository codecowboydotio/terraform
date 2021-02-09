provider "aws" {
  profile = "default"
  region  = var.aws_region
}

resource "aws_instance" "bigip" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  key_name = var.key_name
  user_data = templatefile("user_data.sh.tpl", { 
     bigip_password = var.bigip_password, 
     bigip_license = var.bigip_license 
  })

  tags = {
    for k, v in merge({
      app_type = "bigip"
      Name = "svk-bigip"
    },
    var.default_ec2_tags): k => v
  }

}


data "template_file" "web-init" {
  template = file("web-server.sh.tpl")
  vars = {
    beacon_access_token = var.beacon_access_token
  }
}

resource "aws_instance" "web-server" {
  ami           = var.ami_linux_server
  instance_type = var.instance_type_linux_server
  subnet_id = var.subnet_id
  key_name = var.key_name
  user_data = data.template_file.web-init.rendered
  count = 1

  tags = { 
    for k, v in merge({
      app_type = "web_server"
      Name = "svk_web_server_${count.index + 1}"
    },
    var.default_ec2_tags): k => v
  }
}

data "template_file" "api-init" {
  template = file("api-server.sh.tpl")
  vars = {
    beacon_access_token = var.beacon_access_token
  }
}

resource "aws_instance" "api-server" {
  ami           = var.ami_linux_server
  instance_type = var.instance_type_linux_server
  subnet_id = var.subnet_id
  key_name = var.key_name
  user_data = data.template_file.api-init.rendered
  count = 1

  tags = {
    for k, v in merge({
      app_type = "api_server"
      Name = "svk_api_server_${count.index + 1}"
    },
    var.default_ec2_tags): k => v
  }
}


output "web_server_ip" {
  value = aws_instance.web-server.*.public_ip
}
output "bigip_ip" {
  value = aws_instance.bigip.public_ip
}
output "api_server_ip" {
  value = aws_instance.api-server.*.public_ip
}
