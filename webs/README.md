# Terraform and Consul Web Server spin up in AWS

This section of my repo allows me to spin up any number of webservers that connect and register themselves onto a consul server.
The purpose is to show service discovery with consul.
Each webserver runs a game that real people can connect to.

# Variables:

In order to use this you will need to set some variables first

```
variable "aws_region" {
  default = "your-region"
}
variable "subnet_id" {
  default =  "your-subnet"
}
variable "key_name" {
  default = "your-keypair"
}
variable "ami_linux_server" {
  default = "ami-001ccfbcf4a8e0814"
}
variable "instance_type_linux_server" {
  default = "t2.micro"
}
variable "linux_server_pkgs" {
  default = ["httpd", "net-tools", "unzip"]
}
variable "consul_address" {
  default = "your-consul-server-ip-address"
}
```

aws_region: This is the aws region that you would like to spin up your instances in (us-east1 and so on)
subnet_id: This is the AWS subnet ID that you would like to launch your AWS instances into.
key_name: This is the AWS ssh keypair that you would like to use with the instances.
consul_address: This is the address of the consul server that you would like to register the instances in.
