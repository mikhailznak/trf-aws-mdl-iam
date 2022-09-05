variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}

##################################
# IAM Role
##################################
variable "iam_role_name" {
  description = "Role name"
  type        = string
  default     = ""
}
variable "iam_role_path" {
  description = "Role file path"
  type        = string
  default     = "/"
}
variable "assume_role_services" {
  description = "Assume role services"
  type        = list(string)
  default     = []
}
variable "assume_role_aws_entities" {
  description = "Assume role aws entities"
  type        = list(string)
  default     = []
}

##################################
# Policy
##################################
variable "managed_policy_arn" {
  description = "Managed Policy arn list"
  type        = list(string)
  default     = []
}
variable "customer_managed_policy" {
  description = <<EOD
Customer managed policy.
Usage example:
```
policy_name = {
  policy_path = "/"
  description = "Managed by Terraform"
  policy      = {
    Version = "2012-10-17"
    Statement = [
      {
        Action = [ec2:*]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  }
}
```
EOD
  type        = map(any)
  default     = {}
}
variable "iam_instance_profile" {
  description = "Generate Instance Profile"
  type        = bool
  default     = true
}
