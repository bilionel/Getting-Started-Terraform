# Bucket Name
variable "bucket_name" {
  type        = string
  description = "Name of the s3 bucket to create"
}

# ELB service account arn
variable "elb_service_account_arn" {
  type        = string
  description = "ARN of elb service account"
}

# Common tags
variable "common_tags" {
  type        = map(string)
  description = "list of common tags to apply"
  default     = {}
}
