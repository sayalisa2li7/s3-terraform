# Define AWS provider
provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "static_website" {
  depends_on = [
    aws_s3_bucket_public_access_block.static_website,
    aws_s3_bucket_ownership_controls.static_website,
  ]

  bucket = aws_s3_bucket.static_website.id
  acl    = "public-read"
}


# Create S3 bucket for the static website
resource "aws_s3_bucket" "static_website" {
  bucket = var.bucket_name

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Environment = "Static Website"
  }
}

resource "aws_s3_bucket_object" "index_html" {
  bucket       = aws_s3_bucket.static_website.id
  key          = "index.html"
  source       = "./static_website_content/index.html"  # Update with the actual path to your index.html file
  acl          = "public-read"
  content_type = "text/html"

  # This resource depends on the bucket ACL and ownership controls being applied
  depends_on = [
    aws_s3_bucket_acl.static_website,
    aws_s3_bucket_ownership_controls.static_website,
  ]
}


# Output the website URL
output "website_url" {
  value = aws_s3_bucket.static_website.website_endpoint
}
