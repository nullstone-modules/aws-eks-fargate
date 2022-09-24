module "logs" {
  source = "nullstone-modules/logs/aws"

  // See https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              = "/aws/eks/${local.resource_name}/cluster"
  tags              = local.tags
  enable_log_reader = true
  retention_in_days = 7
  kms_key_arn       = aws_kms_alias.this.arn
}
