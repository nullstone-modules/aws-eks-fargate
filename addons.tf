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

resource "aws_iam_role" "efs_csi" {
  name               = "${local.resource_name}-efs-csi"
  assume_role_policy = data.aws_iam_policy_document.efs_csi_assume.json
  tags               = local.tags
}

data "aws_iam_policy_document" "efs_csi_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.this.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:efs-csi-controller-sa"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.this.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "efs_csi" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
  role       = aws_iam_role.efs_csi.name
}

resource "aws_eks_addon" "efs" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "aws-efs-csi-driver"
  addon_version               = null
  resolve_conflicts_on_update = "PRESERVE"
  service_account_role_arn    = aws_iam_role.efs_csi.arn
  tags                        = local.tags

  timeouts {
    create = "30m"
  }
}
