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
          "Effect" : "Allow",
          "Action" : [
            "s3:*",
            "s3-object-lambda:*"
          ],
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
  bucket = var.bucket_name
  acl    = "private"


  tags = {
    Name = var.bucket_name
  }

}