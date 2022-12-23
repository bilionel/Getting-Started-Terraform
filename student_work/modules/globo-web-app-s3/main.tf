## aws_s3_bucket
resource "aws_s3_bucket" "web_bucket" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = var.common_tags

}

## aws_s3_bucket_policy
resource "aws_s3_bucket_policy" "allow_access_to_s3_bucket" {
  bucket = aws_s3_bucket.web_bucket.id
  policy = data.aws_iam_policy_document.allow_access_to_s3_bucket.json
}

data "aws_iam_policy_document" "allow_access_to_s3_bucket" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.elb_service_account_arn]
    }

    actions = ["s3:PutObject"]

    resources = ["arn:aws:s3:::${var.bucket_name}/alb-logs/*"]

  }

  statement {
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = ["arn:aws:s3:::${var.bucket_name}/alb-logs/*"]

    condition {
      test     = "StringLike"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = ["s3:GetBucketAcl"]

    resources = ["arn:aws:s3:::${var.bucket_name}"]
  }
}


## aws_s3_bucket_acl
resource "aws_s3_bucket_acl" "web_bucket_acl" {
  bucket = aws_s3_bucket.web_bucket.id
  acl    = "private"
}

## aws_iam_role
resource "aws_iam_role" "allow_nginx_s3" {
  name = "${var.bucket_name}-allow_nginx_s3"

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

  tags = var.common_tags
}

## aws_iam_role_policy
resource "aws_iam_role_policy" "allow_s3_all" {
  name = "${var.bucket_name}-allow_s3_all"
  role = aws_iam_role.allow_nginx_s3.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
                "arn:aws:s3:::${var.bucket_name}",
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
    }
  ]
}
EOF

}

## aws_iam_instance_profile
resource "aws_iam_instance_profile" "nginx_profile" {
  name = "${var.bucket_name}-nginx_profile"
  role = aws_iam_role.allow_nginx_s3.name

  tags = var.common_tags
}