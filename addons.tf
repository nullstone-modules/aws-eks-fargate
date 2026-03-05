# TODO:
# load balancer controller
# karpenter or cluster-autoscaler

resource "aws_eks_addon" "secrets" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "aws-secrets-store-csi-driver-provider"
  addon_version               = null
  resolve_conflicts_on_update = "PRESERVE"
  tags                        = local.tags

  timeouts {
    create = "30m"
  }
}

resource "aws_eks_addon" "efs" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "aws-efs-csi-driver"
  addon_version               = null
  resolve_conflicts_on_update = "PRESERVE"
  tags                        = local.tags

  timeouts {
    create = "30m"
  }
}
