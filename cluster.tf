resource "aws_eks_cluster" "this" {
  name                      = local.resource_name
  role_arn                  = aws_iam_role.this.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    subnet_ids             = local.private_subnet_ids
    endpoint_public_access = true
  }

  timeouts {
    delete = "30m"
  }

  depends_on = [
    module.logs,
    aws_iam_role_policy_attachment.this,
    aws_iam_role_policy_attachment.this_service
  ]
}
