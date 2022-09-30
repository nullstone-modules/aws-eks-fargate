resource "aws_eks_cluster" "this" {
  name                      = local.resource_name
  role_arn                  = aws_iam_role.this.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  tags                      = local.tags

  encryption_config {
    resources = ["secrets"]

    provider {
      key_arn = aws_kms_key.this.arn
    }
  }

  #bridgecrew:skip=BC_AWS_KUBERNETES_1:Cluster security group is restricted in aws_security_group.node
  #bridgecrew:skip=BC_AWS_KUBERNETES_2:Enabling Nullstone to provision/deploy into Kubernetes cluster
  vpc_config {
    endpoint_public_access = true
    subnet_ids             = local.private_subnet_ids
    security_group_ids     = [aws_security_group.node.id]
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
