// Setup email domain verification
resource "aws_ses_domain_identity" "domain_identity" {
  domain = var.public_dns_zone
}

resource "aws_route53_record" "domain_identity_records" {
  zone_id = var.public_dns_zone_id
  name    = "_amazonses.${var.public_dns_zone}"
  type    = "TXT"
  ttl     = "600"

  records = [
    aws_ses_domain_identity.domain_identity.verification_token,
  ]
}

// Setup "mail from" verification
resource "aws_ses_domain_mail_from" "mail_from" {
  domain           = aws_ses_domain_identity.domain_identity.domain
  mail_from_domain = "monitoring.${aws_ses_domain_identity.domain_identity.domain}"
}

# Route53 MX record
resource "aws_route53_record" "example_ses_domain_mail_from_mx" {
  zone_id = var.public_dns_zone_id
  name    = aws_ses_domain_mail_from.mail_from.mail_from_domain
  type    = "MX"
  ttl     = "600"
  records = ["10 feedback-smtp.${var.aws_region}.amazonses.com"]
}

# Route53 TXT record for SPF
resource "aws_route53_record" "example_ses_domain_mail_from_txt" {
  zone_id = var.public_dns_zone_id
  name    = aws_ses_domain_mail_from.mail_from.mail_from_domain
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]
}

// Setup email DKIM verification
resource "aws_ses_domain_dkim" "domain_dkim" {
  domain = aws_ses_domain_identity.domain_identity.domain
}

resource "aws_route53_record" "amazonses_dkim_record" {
  count   = 3
  zone_id = var.public_dns_zone_id
  name    = "${element(aws_ses_domain_dkim.domain_dkim.dkim_tokens, count.index)}._domainkey.${var.public_dns_zone}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.domain_dkim.dkim_tokens, count.index)}.dkim.${var.public_dns_zone}"]
}

// Create AWS SES SMTP user and policy
resource "aws_iam_user" "ses_iam_user" {
  name          = "${var.environment}-ses-iam-user"
  path          = "/${var.environment}/"
  force_destroy = true
}

resource "aws_iam_access_key" "ses_iam_access_key" {
  user = aws_iam_user.ses_iam_user.name
}

data "aws_iam_policy_document" "ses_send_access" {
  statement {
    effect = "Allow"

    actions = [
      "ses:SendRawEmail",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "this" {
  name_prefix = "SESSendOnlyAccess"
  user        = aws_iam_user.ses_iam_user.name

  policy = data.aws_iam_policy_document.ses_send_access.json
}
