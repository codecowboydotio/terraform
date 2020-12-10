resource "aws_instance" "bigip" {
  ami           = var.ami_bigip
  instance_type = var.instance_type_bigip
  subnet_id = aws_subnet.mgmt.id
  key_name = var.key_name
  user_data = templatefile("bigip.sh.tpl", {
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

  depends_on = [aws_subnet.mgmt]
}

output "bigip_public_ip" {
  value = aws_instance.bigip.*.public_ip
}
