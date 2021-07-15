resource "aws_iam_role" "CFE_role" {
  
  name = "${var.name-prefix}-${var.project}-cfe-iam-role"
  assume_role_policy = file("CFE_Role.json")

  tags = {
    for k, v in merge({
      app_type = "production"
      Name = "${var.name-prefix}-${var.project}-vpc-a"
    },
    var.default_ec2_tags): k => v
  }
}

resource "aws_iam_role_policy" "CFE_policy" {
  
  name = "${var.name-prefix}-${var.project}-cfe-iam-role-policy"
  role = aws_iam_role.CFE_role.id
  policy = file("CFE_Policy.json")
}

resource "aws_iam_instance_profile" "CFE_profile" {
  
  name = "${var.name-prefix}-${var.project}-cfe-iam-instance-profile"
  role = aws_iam_role.CFE_role.name
}
