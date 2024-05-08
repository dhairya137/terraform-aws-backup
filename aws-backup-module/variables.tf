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
  description = "A map of required tags and their allowed values"
  type        = map(string)

  validation {
    condition = alltrue([
      for key, value in var.required_tags : contains(["ApplicationName", "Client", "Owner", "ProjectName", "OwnerEmail"], key)
    ])
    error_message = "Only the following tag keys are allowed: ApplicationName, Client, Owner, ProjectName, OwnerEmail."
  }

  validation {
    condition = alltrue([
      for key, value in var.required_tags : key == "OwnerEmail" ? can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", value)) : true
    ])
    error_message = "The OwnerEmail tag value must be a valid email address."
  }
}


# variable "allowed_tag_keys" {
#   description = "A list of allowed tag keys"
#   type        = list(string)
#   default     = ["ApplicationName", "Client", "Owner", "ProjectName", "OwnerEmail"]
# }