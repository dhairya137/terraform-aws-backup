module "ec2_backup" {
  source        = "./aws-backup-module"
  resource_type = "ec2"
  resource_ids = ["instance/i-0efaeeeccb3be84d8"]
  
  # Additional backup plan  configuration variables
}

# module "s3_backup" {
#   source        = "./aws-backup-module"
#   resource_type = "s3"
#   resource_ids = ["dpdpdp1313", "dpcompi131"]

#   # Additional backup plan configuration variables
# }

# module "rds_backup" {
#   source        = "./aws-backup-module"
#   resource_type = "rds"
#   resource_ids  = ["arn:aws:rds:us-west-2:123456789012:db/my-rds-instance"]

#   # Additional backup plan configuration variables
# }
