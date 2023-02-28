output "ses_email_smtp_id" {
  value     = aws_iam_access_key.ses_iam_access_key.id
  sensitive = true
}

output "ses_email_smtp_password" {
  value     = aws_iam_access_key.ses_iam_access_key.ses_smtp_password_v4
  sensitive = true
}
