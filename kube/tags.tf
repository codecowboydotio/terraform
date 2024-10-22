variable "default_ec2_tags" {
  description = "Default set of tags to apply to EC2 instances"
  type        = map
  default = {
    approver    = "marc.brown"
    expirationDate = "never"
    owner = "scott.vankalken"
    purpose = "testing"
  }
}
