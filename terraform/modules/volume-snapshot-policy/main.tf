resource "aws_iam_role" "dlm_lifecycle_role" {
  name = "${var.environment}-dlm-lifecycle-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "dlm.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "dlm_lifecycle_policy" {
  name = "${var.environment}-dlm_lifecycle-policy"
  role = aws_iam_role.dlm_lifecycle_role.id

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Effect": "Allow",
         "Action": [
            "ec2:CreateSnapshot",
            "ec2:DeleteSnapshot",
            "ec2:DescribeVolumes",
            "ec2:DescribeSnapshots"
         ],
         "Resource": "*"
      },
      {
         "Effect": "Allow",
         "Action": [
            "ec2:CreateTags"
         ],
         "Resource": "arn:aws:ec2:*::snapshot/*"
      }
   ]
}
EOF
}

resource "aws_dlm_lifecycle_policy" "data_disk_snapshot_lifecycle_policy" {
  description        = "${var.environment} data disk snapshot lifecycle policy"
  execution_role_arn = aws_iam_role.dlm_lifecycle_role.arn
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "${var.environment} daily data disk snapshot"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["01:00"]
      }

      retain_rule {
        // Keep snapshots for ~1 months
        count = 30
      }

      tags_to_add = { # example tags for each host
        SnapshotCreator = "${var.environment}-data-disk-snapshot-policy"
        backupResource = "false"
      }

      copy_tags = true
    }

    target_tags = {
      Snapshot = var.environment
    }
  }
  tags = merge(var.tags, { Name : "${var.environment}-data-disk-snapshot-policy" })
}
