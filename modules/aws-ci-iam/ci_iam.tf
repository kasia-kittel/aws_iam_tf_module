# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 3.0"
#     }
#   }
# }

# provider "aws" {
#   region = "us-west-2"
# }


locals {
  tags = merge(
    var.additional_tags,
    {
      env = var.env_suffix
    },
  )
}

# A role
data "aws_caller_identity" "source" {
  provider = aws
}

data "aws_iam_policy_document" "assume_role" {
  provider = aws
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.source.account_id}:root"]
    }
  }
}

resource "aws_iam_role" "ci_role" {
  name               = "${var.env_suffix}-ci-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = local.tags
}

# A policy, allowing users / entities to assume the above role,
data "aws_iam_policy_document" "allow_assume_ci_role" {
  provider = aws
  statement {
    actions   = ["sts:AssumeRole"]
    effect    = "Allow"
    resources = [aws_iam_role.ci_role.arn]
  }
}

resource "aws_iam_policy" "ci_policy" {
  name   = "${var.env_suffix}-ci-policy"
  policy = data.aws_iam_policy_document.allow_assume_ci_role.json
  tags   = local.tags
}

# A group, with the above policy attached,
resource "aws_iam_group" "ci_group" {
  name = "${var.env_suffix}-ci-group"
}

resource "aws_iam_group_policy_attachment" "ci_policy_attachment" {
  group      = aws_iam_group.ci_group.name
  policy_arn = aws_iam_policy.ci_policy.arn
}

#  A user, belonging to the above group.
resource "aws_iam_user" "ci_user" {
  name = "${var.env_suffix}-ci-user"
  tags = local.tags
}

resource "aws_iam_user_group_membership" "ci_user_group_membership" {
  user = aws_iam_user.ci_user.name
  groups = [
    aws_iam_group.ci_group.name,
  ]
}