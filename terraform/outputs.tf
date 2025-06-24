output "amplify_app_id" {
  description = "Amplify App ID"
  value       = aws_amplify_app.spa_app.id
}

output "amplify_default_domain" {
  description = "Default Amplify domain"
  value       = "https://${aws_amplify_branch.main_branch.branch_name}.${aws_amplify_app.spa_app.default_domain}"
}

output "amplify_app_arn" {
  description = "Amplify App ARN"
  value       = aws_amplify_app.spa_app.arn
}