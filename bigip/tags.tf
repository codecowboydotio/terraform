variable "default_ec2_tags" {
  description = "Default set of tags to apply to EC2 instances"
  type        = map
  default = {
    Name        = "svk"
    Owner       = "svk"
    Environment = "Production"
    SupportTeam = "ANZSE"
    Contact     = "svk@example.com"
  }
}
