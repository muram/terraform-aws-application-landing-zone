# Create an IAM user with access key
resource "aws_iam_user" "user" {
  name = "${var.app_name}-tf-user"
}

resource "aws_iam_access_key" "user-key" {
  user = aws_iam_user.user.name
}

resource "aws_iam_user_policy" "user-policy" {
  name = "${var.app_name}-tf-policy"
  user = aws_iam_user.user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
            "ec2:*",
            "iam:*",
            "s3:*",
            "autoscaling:*",
            "elasticloadbalancing:*"
        ]
        Effect   = "Allow"
        Resource = "*" # Temp wildcard. Needs to specify the LZ resources for the app.
      },
    ]
  })
}