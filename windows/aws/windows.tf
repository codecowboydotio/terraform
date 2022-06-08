resource "aws_instance" "windows" {
#  ami		= "ami-00967bac0f4c472c5"
  ami		= data.aws_ami.distro.id
  instance_type = var.instance_type_linux_server
  subnet_id = aws_subnet.vpc-a_subnet_1.id
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.vpc-a_allow_all.id]
  user_data = data.template_file.userdata_win.rendered

  tags = {
    for k, v in merge({
      app_type = "web"
      Name = "${var.name-prefix}-${var.project}-windows-server"
    },
    var.default_ec2_tags): k => v
  }
}

data "template_file" "userdata_win" {
    template = <<EOF
    <script>
    echo "" > _INIT_STARTED_
    net user ${var.win_username} /add /y
    net user ${var.win_username} ${var.win_password}
    net localgroup administrators tester /add
    powershell.exe Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
    powershell.exe [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
    powershell.exe Install-Package -Name docker -ProviderName DockerMsftProvider
    echo "" > _INIT_COMPLETE_
    </script>
    <persist>false</persist>
    EOF
}


output "windows_internal" {
  value = aws_instance.windows.private_ip
}
output "windows_external" {
  value = aws_instance.windows.public_ip
}
