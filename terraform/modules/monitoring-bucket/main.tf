# Create an S3 bucket to store the state file
resource "aws_s3_bucket" "monitoring_bucket" {
  bucket = "${var.environment}-watr-monitoring-bucket"
  acl    = "private"

  tags = merge(var.tags, {
    Name = "${var.environment} monitoring bucket"
  })
}

# Block any public access for the bucket
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.monitoring_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role_policy" "monitoring_bucket_access" {
  name = "${var.environment}-monitoring-bucket-access"
  role = var.collator_nodes_iam_role_id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": ["s3:ListBucket"],
        "Effect": "Allow",
        "Resource": ["${aws_s3_bucket.monitoring_bucket.arn}"]
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource": ["${aws_s3_bucket.monitoring_bucket.arn}/*"]
      }
    ]
  }
  EOF
}
