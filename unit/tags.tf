variable "default_ec2_tags" {
  description = "Default set of tags to apply to EC2 instances"
  type        = map
  default = {
    Owner       = "svk@f5.com"
    Environment = "Demo"
    SupportTeam = "ANZSE"
    Contact     = "svk@example.com"
  }
}
