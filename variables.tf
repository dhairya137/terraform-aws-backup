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
