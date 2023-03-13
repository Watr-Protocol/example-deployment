output "cloudwatch_iam_profile" {
  value = aws_iam_instance_profile.node_iam_instance_profile.name
}