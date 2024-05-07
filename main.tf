module "ec2_backup" {
  source        = "./aws-backup-module"
  aws_region    = "ap-south-1"
  resource_type = "ec2"
  resource_ids  = ["arn:aws:ec2:ap-south-1:571653956102:instance/i-0efaeeeccb3be84d8"]
  backup_rules  = var.backup_rules
  required_tags = {
    ApplicationName = "Production"
    Client     = "Client"
    Owner        = "Owner"
    ProjectName = "Project"
    OwnerEmail = "abc@example.com"
  }
}

module "s3_backup" {
  source        = "./aws-backup-module"
  aws_region    = "ap-south-1"
  resource_type = "s3"
  resource_ids  = ["arn:aws:s3:::dpcompi131", "arn:aws:s3:::dpdpdp1313"]
  backup_rules  = var.backup_rules

  required_tags = {
    ApplicationName = "Production"
    Client     = "Client"
    Owner        = "Owner"
    ProjectName = "Project"
    OwnerEmail = "abc@example.com"
  }
}

# module "rds_backup" {
#   source        = "./aws-backup-module"
#   aws_region    = "ap-south-1"
#   resource_type = "rds"
#   resource_ids  = ["arn:aws:rds:ap-south-1:123456789012:db/my-rds-instance"]
# }
