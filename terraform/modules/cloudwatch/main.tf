resource "aws_iam_instance_profile" "node_iam_instance_profile" {
  name = "${var.cloudwatch_iam_profile}"
  role = aws_iam_role.node_iam_role.name
}

resource "aws_iam_role" "node_iam_role" {
  name = "${var.environment}-nodes-iam-role"

  description = "Allows EC2 instances to call AWS services on your behalf."

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "ssm" {
  name       = "AmazonSSMManagedInstanceCore"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  roles      = [aws_iam_role.node_iam_role.name]
}

resource "aws_iam_policy_attachment" "cloudwatch" {
  name       = "CloudWatchAgentServerPolicy"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  roles      = [aws_iam_role.node_iam_role.name]
}
