resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

resource "aws_iam_policy_attachment" "ssm" {
  name       = "AmazonSSMManagedInstanceCore"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  roles      = [aws_iam_role.this.name]
}

resource "aws_iam_policy_attachment" "cloudwatch" {
  name       = "CloudWatchAgentServerPolicy"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  roles      = [aws_iam_role.this.name]
}


# locals {
#   role_policy_arns = [
#     "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
#     "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
#   ]
# }

# resource "aws_iam_instance_profile" "this" {
#   name = "ec2-profile-sts"
#   role = aws_iam_role.this.name
# }

# resource "aws_iam_role_policy_attachment" "this" {
#   count = length(local.role_policy_arns)

#   role       = aws_iam_role.this.name
#   policy_arn = element(local.role_policy_arns, count.index)
# }

# resource "aws_iam_role_policy" "this" {
#   name = "ec2-inline-policy-sts"
#   role = aws_iam_role.this.id
#   policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Effect" : "Allow",
#           "Action" : [
#             "ssm:GetParameter"
#           ],
#           "Resource" : "*"
#         }
#       ]
#     }
#   )
# }

# resource "aws_iam_role" "this" {
#   name      = "ec2-role-sts"
#   path      = "/"

#   assume_role_policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Action" : "sts:AssumeRole",
#           "Principal" : {
#             "Service" : "ec2.amazonaws.com"
#           },
#           "Effect" : "Allow"
#         }
#       ]
#     }
#   )
# }
