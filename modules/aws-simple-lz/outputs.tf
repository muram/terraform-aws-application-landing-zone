output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.example_bucket.arn
}

output "aws_access_key_id" {
  value = aws_iam_access_key.user-key.id
}

output "aws_secret_access_key" {
  value = aws_iam_access_key.user-key.secret
  sensitive = true
}