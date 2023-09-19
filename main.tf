provider "aws" {
  region = "us-east-2" 
}

# Create an S3 bucket for your website
resource "aws_s3_bucket" "my_bucket" {
  bucket = "donaldndubuizu.com"          
}

resource "aws_s3_bucket_ownership_controls" "my_bucket" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "my_bucket" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "my_bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.my_bucket,
    aws_s3_bucket_public_access_block.my_bucket,
  ]

  bucket = aws_s3_bucket.my_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "my_bucket" {
  bucket = aws_s3_bucket.my_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.my_bucket.id
  key = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "project" {
  bucket = aws_s3_bucket.my_bucket.id
  key = "projects.html"
  source = "projects.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "project1" {
  bucket = aws_s3_bucket.my_bucket.id
  key = "project1.html"
  source = "project1.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "contact" {
  bucket = aws_s3_bucket.my_bucket.id
  key = "contact.html"
  source = "contact.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "js_script" {
  bucket = aws_s3_bucket.my_bucket.id
  key = "script.js"
  source = "script.js"
  acl = "public-read"
}

resource "aws_s3_object" "css_style" {
  bucket = aws_s3_bucket.my_bucket.id
  key = "style.css"
  source = "style.css"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.my_bucket.id
  key = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.my_bucket.id
  key = "profile.png"
  source = "profile.png"
  acl = "public-read"
}

resource "aws_route53_record" "portfolio" {
  zone_id = "/hostedzone/Z02334231IZXHWH94IHVR"
  name    = "donaldndubuizu.com"
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.my_bucket.website_domain
    zone_id                = aws_s3_bucket.my_bucket.hosted_zone_id
    evaluate_target_health = false
  }
}