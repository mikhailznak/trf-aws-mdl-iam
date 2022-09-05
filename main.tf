locals {
  assume_role_policy_principals = {
    services_only = [
      {
        type        = "Service"
        identifiers = var.assume_role_services
      },
    ]
    aws_entities_only = [
      {
        type        = "AWS"
        identifiers = var.assume_role_aws_entities
      },
    ]
    services_and_entities = [
      {
        type        = "Service"
        identifiers = var.assume_role_services
      },
      {
        type        = "AWS"
        identifiers = var.assume_role_aws_entities
      },
    ]
    unspecified = []
  }
}

##################################
# IAM Role
##################################
data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]

    dynamic "principals" {
      for_each = local.assume_role_policy_principals[
        length(var.assume_role_services) > 0 && length(var.assume_role_aws_entities) > 0 ? "services_and_entities" : length(var.assume_role_services) > 0 && length(var.assume_role_aws_entities) == 0 ? "services_only" : length(var.assume_role_services) == 0 && length(var.assume_role_aws_entities) > 0 ? "aws_entities_only" : "unspecified"
      ]
      content {
        type        = principals.value.type
        identifiers = principals.value.identifiers
      }
    }
  }
}
resource "aws_iam_role" "this" {
  name               = var.iam_role_name
  path               = var.iam_role_path
  assume_role_policy = data.aws_iam_policy_document.this.json
  tags = merge(
    {
      "Name" = var.iam_role_name
    },
    var.tags
  )
}

##################################
# Attach Managed Policy
##################################
resource "aws_iam_role_policy_attachment" "aws_managed" {
  for_each   = toset(var.managed_policy_arn)
  policy_arn = each.value

  role = aws_iam_role.this.name
}

##################################
# Customer Managed Policy
##################################
resource "aws_iam_policy" "customer_managed" {
  for_each = var.customer_managed_policy

  name        = "${var.iam_role_name}-${each.key}"
  path        = lookup(each.value, "policy_path", "/")
  description = lookup(each.value, "description", "Managed by Terraform")
  policy      = jsonencode(lookup(each.value, "policy"))
  tags = merge(
    {
      "Name" = "${var.iam_role_name}-${each.key}"
    },
    var.tags
  )
}
resource "aws_iam_role_policy_attachment" "customer_managed" {
  for_each   = aws_iam_policy.customer_managed
  policy_arn = lookup(each.value, "arn")

  role = aws_iam_role.this.name
}

##################################
# IAM Instance Profile
##################################
resource "aws_iam_instance_profile" "this" {
  count = var.iam_instance_profile ? 1 : 0
  name  = "${var.iam_role_name}-profile"
  role  = aws_iam_role.this.name
}