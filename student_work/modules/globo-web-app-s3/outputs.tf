# Bucket object
output "bucket" {
  value = aws_s3_bucket.web_bucket
}

# Instance profile object
output "nginx_instance_profile" {
  value = aws_iam_instance_profile.nginx_profile
}
