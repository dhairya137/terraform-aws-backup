# Configure AWS provider
provider "aws" {
  region = var.aws_region
}

locals {
  required_tags_provided = length(var.required_tags) > 0
}


data "aws_caller_identity" "current" {}

data "aws_kms_key" "aws_backup_key" {
  key_id = "alias/aws/backup"
}

# Create an AWS Backup vault
resource "aws_backup_vault" "backup_vault" {
  count = local.required_tags_provided ? 1 : 0

  name        = "backup-vault-${var.resource_type}"
  kms_key_arn = data.aws_kms_key.aws_backup_key.arn

  tags = var.required_tags
}

# Create an IAM role for AWS Backup
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

# Create an AWS Backup plan
resource "aws_backup_plan" "backup_plan" {
  count = local.required_tags_provided ? 1 : 0

  name = "backup-plan-${var.resource_type}"

  # Define backup plan rules based on the resource type
  dynamic "rule" {
    for_each = var.backup_rules[var.resource_type] != null ? [var.backup_rules[var.resource_type]] : []
    content {
      rule_name                = "backup-rule-${var.resource_type}"
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

  tags = var.required_tags
}




# Create an AWS Backup selection
resource "aws_backup_selection" "backup_selection" {
  iam_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/service-role/AWSBackupDefaultServiceRole"
  name         = "backup-selection-${var.resource_type}"
  plan_id      = aws_backup_plan.backup_plan.id

  # Assign resources based on the provided resource IDs or ARNs
  resources = var.resource_ids

}
