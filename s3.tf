resource "aws_iam_role" "ws_role" {
  name = "ws_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    name = "ws_role"
  }
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "s3_policy"
  role = aws_iam_role.ws_role.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "ObjectLevel",
          "Effect" : "Allow",
          "Action" : [
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject",
            "s3:PutObjectAcl"
          ],
          "Resource" : "arn:aws:s3:::${var.bucket_name}/*"
        },
        {
          "Sid" : "BucketLevel",
          "Effect" : "Allow",
          "Action" : [
            "s3:GetBucketPublicAccessBlock",
            "s3:PutBucketPublicAccessBlock",
            "s3:GetBucketOwnershipControls",
            "s3:PutBucketOwnershipControls",
            "s3:CreateBucket",
            "s3:ListBucket",
            "s3:GetBucketLocation"
          ],
          "Resource" : "arn:aws:s3:::*"
        },
        {
          "Sid" : "AccountLevel",
          "Effect" : "Allow",
          "Action" : "s3:ListAllMyBuckets",
          "Resource" : "*"
        }
      ]
    }
  )
}

resource "aws_iam_instance_profile" "ws_s3_iam_profile" {
  name = "ws_s3_iam_profile"
  role = aws_iam_role.ws_role.name

}

resource "aws_s3_bucket" "ws_s3_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
  tags = {
    Name = var.bucket_name
  }

}

resource "aws_s3_bucket_acl" "s3_acl" {
  bucket = aws_s3_bucket.ws_s3_bucket.id
  acl    = "private"
}