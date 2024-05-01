backup_rules = {
  ec2 = {
    schedule            = "cron(0 15 ? * * *)"
    start_window        = 60
    completion_window   = 420
    recovery_point_tags = { Environment = "production" }
    cold_storage_after  = 30
    delete_after        = 120
  }
  s3 = {
    schedule            = "cron(0 8 ? * * *)"
    start_window        = 60
    completion_window   = 420
    recovery_point_tags = { Environment = "production" }
    cold_storage_after  = 30
    delete_after        = 120
  }
  # Add more resource types as needed
}
