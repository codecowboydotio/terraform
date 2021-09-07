variable "ns" { default = "s-vankalken" }

variable "name-prefix" { default = "svk" }
variable "project" { default = "eks" }
variable "aws_region" { default = "ap-southeast-2" }

variable "cluster_name" {
  type        = string
  description = "EKS cluster name."
  default = "svk-cluster"
}

variable "eks_vpc_cidr_block" {
  default = "10.100.0.0/16"
}
variable "vpc-outside" {
  default = "10.100.1.0/24"
}
variable "vpc-inside" {
  default = "10.100.2.0/24"
}

