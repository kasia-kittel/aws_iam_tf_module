output "ci_role" {
  value       = aws_iam_role.ci_role
  description = "CI role"
}

output "ci_policy" {
  value       = aws_iam_policy.ci_policy
  description = "CI policy"
}

output "ci_group" {
  value       = aws_iam_group.ci_group
  description = "CI group"
}

output "ci_user" {
  value       = aws_iam_user.ci_user
  description = "CI user"
}
