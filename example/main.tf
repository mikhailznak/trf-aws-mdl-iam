module "example" {
  source = "../"
  tags = {
    "Env" = "dev"
  }
  iam_role_name        = "test"
  iam_role_path        = "/"
  assume_role_services = ["ec2.amazonaws.com"]
  managed_policy_arn   = ["arn:aws:iam::aws:policy/job-function/SupportUser"]
  customer_managed_policy = {
    "policy_name" = {
      policy_path = "/"
      description = "Managed by Terraform"
      policy = {
        Version = "2012-10-17"
        Statement = [
          {
            Action   = ["ec2:*"]
            Effect   = "Allow"
            Resource = "*"
          },
        ]
      }
    }
  }
}


