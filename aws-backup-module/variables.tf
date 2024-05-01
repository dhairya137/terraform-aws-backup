variable "resource_type" {
  description = "The type of AWS resource to back up (e.g., 'ec2', 'rds', 'efs', 'dynamodb')"
  type        = string
}

variable "resource_ids" {
  description = "A list of resource IDs or ARNs to include in the backup plan"
  type        = list(string)
}

variable "backup_rules" {
  description = "A map of backup rules for different resource types"
  type        = map(any)
  default     = {}
}

variable "timezone" {
  description = "The timezone to use for scheduling backups"
  type        = string
  default     = "IST"
}

# Additional variables for backup plan configuration (e.g., schedule, retention, etc.)
