##################################
# IAM Role
##################################
output "iam_role_id" {
  value = module.example.iam_role_id
}
output "iam_role_arn" {
  value = module.example.iam_role_arn
}
output "iam_role_name" {
  value = module.example.iam_role_name
}

##################################
# Instance Profile
##################################
output "aws_iam_instance_profile_arn" {
  value = module.example.aws_iam_instance_profile_arn
}