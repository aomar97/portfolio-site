variable "region" {
  description = "AWS region for the S3 bucket."
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Public site FQDN, e.g. portfolio.example.com."
  type        = string
  default     = "portfolio.example.com"
}

variable "hosted_zone_name" {
  description = "Existing Route53 hosted zone that owns domain_name, e.g. example.com."
  type        = string
  default     = "example.com"
}

variable "bucket_name" {
  description = "Globally-unique S3 bucket name for the site content."
  type        = string
  default     = "aomar97-portfolio-site"
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default = {
    Project   = "portfolio-site"
    ManagedBy = "terraform"
  }
}
