
resource "aws_iam_role" "cloudwatch_role" {
  name = "cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "cloudwatch_policy" {
  name_prefix = "cloudwatch-policy-"

  role = aws_iam_role.cloudwatch_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "cloudwatch_instance_profile" {
  name = "cloudwatch-instance-profile"

  roles = [aws_iam_role.cloudwatch_role.name]
}

resource "aws_cloudwatch_log_group" "example_log_group" {
  name = "/aws/ec2/example"
}

resource "aws_cloudwatch_log_stream" "example_log_stream" {
  name            = "example"
  log_group_name  = aws_cloudwatch_log_group.example_log_group.name
  depends_on      = [aws_cloudwatch_log_group.example_log_group]
}

module "cloudwatch_instances" {
  source = "../ec2-instance"

  for_each = var.cloudwatch

  name              = "${var.environment}-${each.key}"
  environment       = var.environment
  instance_type     = each.value.instance_type

  tags = merge(var.tags, {
    InstanceType : "cloudwatch"
  })
}