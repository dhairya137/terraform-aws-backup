output "backup_plan_id" {
  description = "The ID of the created backup plan"
  value       = aws_backup_plan.backup_plan[0].id
}

output "backup_selection_id" {
  description = "The ID of the created backup selection"
  value       = aws_backup_selection.backup_selection[0].id
}

output "backup_vault_id" {
  description = "The ID of the created backup vault"
  value       = aws_backup_vault.backup_vault[0].id
}
