variable "default_ec2_tags" {
  description = "Default set of tags to apply to EC2 instances"
  type        = map
  default = {
    Owner       = "svk"
    Environment = "Demo"
    SupportTeam = "AU-SE"
    Contact     = "svk"
  }
}
