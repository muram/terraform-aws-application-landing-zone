locals {
  s3_bucket_name = "${var.app_name}-landing-zone-bucket-${random_id.bucket_id.hex}"
}

resource random_id "bucket_id" {
  byte_length = 4
}

# Create an S3 bucket
resource "aws_s3_bucket" "example_bucket" {
    bucket = local.s3_bucket_name

    tags = {
        Name = "${var.app_name}-landing-zone-bucket"
    }
}

# Set ownership controls for the S3 bucket
resource "aws_s3_bucket_ownership_controls" "example" {
    bucket = aws_s3_bucket.example_bucket.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}

# Set Access Control List (ACL) for the S3 bucket
resource "aws_s3_bucket_acl" "example" {
    depends_on = [aws_s3_bucket_ownership_controls.example]

    bucket = aws_s3_bucket.example_bucket.id
    acl    = "private"
}