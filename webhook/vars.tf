variable "aws_region" {
  default = "ap-southeast-2"
}
variable "name-prefix" {
  default = "svk"
}
variable "project" {
  default = "webhook-demo"
}
variable "vpc-a_cidr_block" {
  default = "10.100.0.0/16"
}

variable "vpc-a_subnet_1" {
  default = "10.100.1.0/24"
}
variable "key_name" {
  default = "svk-key"
}

