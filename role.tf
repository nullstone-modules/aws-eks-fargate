resource "aws_iam_role" "this" {
  name               = local.resource_name
  assume_role_policy = data.aws_iam_policy_document.this_assume.json
  tags               = local.tags
}

data "aws_iam_policy_document" "this_assume" {
  statement {
    sid     = "AssumeEKS"
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type = "Service"
      identifiers = [
        "eks.amazonaws.com",
        "eks-fargate-pods.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "this_basic" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "this_service" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.this.name
}

# Enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "this_vpc" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.this.name
}

# Node IAM role for EKS Auto Mode
resource "aws_iam_role" "node" {
  count              = var.enable_auto_mode ? 1 : 0
  name               = "${local.resource_name}-node"
  assume_role_policy = data.aws_iam_policy_document.node_assume.json
  tags               = local.tags
}

data "aws_iam_policy_document" "node_assume" {
  statement {
    sid     = "AssumeEC2"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "node_minimal" {
  count      = var.enable_auto_mode ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy"
  role       = aws_iam_role.node[0].name
}

resource "aws_iam_role_policy_attachment" "node_ecr" {
  count      = var.enable_auto_mode ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.node[0].name
}

# Required managed policies for EKS Auto Mode on the cluster role
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/auto-cluster-iam-role.html
resource "aws_iam_role_policy_attachment" "this_eks_block_storage" {
  count      = var.enable_auto_mode ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "this_eks_compute" {
  count      = var.enable_auto_mode ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "this_eks_load_balancing" {
  count      = var.enable_auto_mode ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "this_eks_networking" {
  count      = var.enable_auto_mode ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
  role       = aws_iam_role.this.name
}
