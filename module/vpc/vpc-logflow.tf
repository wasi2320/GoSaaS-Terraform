/* module "vpc-flowlogs-role" {
  source                   = "./modules/IAM"
  role_name                = "vpc-flow-logs"
  role_description         = "role for vpc for publishing flow logs on cloudwatch"
  role_assume_policy       = data.aws_iam_policy_document.vpc-flowlogs-trust-policy.json
  role_managed_policy_arns = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${aws_iam_policy.vpc-flow-logs-policy.name}"]
}
 */