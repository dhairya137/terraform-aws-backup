variable "aws_region" {
  description = "AWS region to create resources"
  type        = string
}

variable "resource_type" {
  description = "The type of AWS resource to back up (e.g., 'ec2', 's3', 'rds')"
  type        = string
}

variable "resource_ids" {
  description = "A list of resource IDs or ARNs to include in the backup plan"
  type        = list(string)
}
