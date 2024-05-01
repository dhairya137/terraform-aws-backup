terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.19"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

locals {
  backup_rules = {
    ec2 = {
      rule_name           = "ec2-backup-rule"
      schedule            = "cron(0 5 ? * * *)" # Daily at 5:00 AM UTC
      start_window        = 60
      completion_window   = 120
      recovery_point_tags = { Environment = "production" }
      cold_storage_after  = 10
      delete_after        = 100
      schedule_timezone   = "Asia/Kolkata"
    }
    rds = {
      rule_name           = "rds-backup-rule"
      schedule            = "cron(0 6 ? * * *)" # Daily at 6:00 AM UTC
      start_window        = 60
      completion_window   = 120
      recovery_point_tags = { Environment = "production" }
      cold_storage_after  = 10
      delete_after        = 100
      schedule_timezone   = "Asia/Kolkata"
    }
    s3 = {
      rule_name           = "s3-backup-rule"
      schedule            = "cron(0 6 ? * * *)" # Daily at 6:00 AM UTC
      start_window        = 60
      completion_window   = 120
      recovery_point_tags = { Environment = "production" }
      cold_storage_after  = 10
      delete_after        = 100
      schedule_timezone   = "Asia/Kolkata"
    }
    # Add more resource types and their corresponding backup rules
  }
}

resource "aws_backup_vault" "backup_vault" {
  name        = "backup-vault-${var.resource_type}"
  kms_key_arn = aws_kms_key.backup_key.arn
}

resource "aws_kms_key" "backup_key" {
  description             = "Backup Key"
  deletion_window_in_days = 10
}


resource "aws_backup_plan" "backup_plan" {
  name = "backup-plan-${var.resource_type}"

  # Define backup plan rules based on the resource type
  dynamic "rule" {
    for_each = local.backup_rules
    content {
      rule_name                = rule.value.rule_name
      target_vault_name        = aws_backup_vault.backup_vault.name
      schedule                 = rule.value.schedule
      start_window             = rule.value.start_window
      completion_window        = rule.value.completion_window
      recovery_point_tags      = rule.value.recovery_point_tags
      lifecycle {
        cold_storage_after = rule.value.cold_storage_after
        delete_after       = rule.value.delete_after
      }
    }
  }
}

data "aws_iam_policy_document" "backup_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "backup_role" {
  name               = "BackupRole-${var.resource_type}"
  assume_role_policy = data.aws_iam_policy_document.backup_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "backup_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_role.name
}


# resource "aws_backup_selection" "backup_selection" {
#   iam_role_arn = aws_iam_role.backup_role.arn
#   name         = "backup-selection-${var.resource_type}"
#   plan_id      = aws_backup_plan.backup_plan.id

#   # Assign resources based on the provided resource IDs or ARNs
#   dynamic "resources_selection" {
#     for_each = var.resource_ids
#     content {
#       resources = [resources_selection.value]
#     }
#   }
# }

resource "aws_backup_selection" "backup_selection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "backup-selection-${var.resource_type}"
  plan_id      = aws_backup_plan.backup_plan.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "True"
  }
}