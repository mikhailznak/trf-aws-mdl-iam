##################################
# IAM Role
##################################
output "iam_role_id" {
  value = aws_iam_role.this.id
}
output "iam_role_arn" {
  value = aws_iam_role.this.arn
}
output "iam_role_name" {
  value = aws_iam_role.this.name
}

##################################
# Instance Profile
##################################
output "aws_iam_instance_profile_arn" {
  value = var.iam_instance_profile ? aws_iam_instance_profile.this[0].arn : ""
}