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
