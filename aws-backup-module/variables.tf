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

variable "backup_rules" {
  description = "A map of backup rules for different resource types"
  type        = map(object({
    schedule            = string
    start_window        = number
    completion_window   = number
    recovery_point_tags = map(string)
    cold_storage_after  = number
    delete_after        = number
  }))
  default     = {}
}

variable "required_tags" {
  description = "A map of required tags to be applied to all resources"
  type        = map(string)
}
