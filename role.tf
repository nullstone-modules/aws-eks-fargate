resource "aws_iam_role" "this" {
  name                  = local.resource_name
  assume_role_policy    = data.aws_iam_policy_document.this_assume.json
  force_detach_policies = true
  tags                  = local.tags
}

data "aws_iam_policy_document" "this_assume" {
  statement {
    sid     = "AssumeEKS"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "eks.amazonaws.com",
        "eks-fargate-pods.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_policy" "this" {
  name   = "${local.resource_name}-cluster_role"
  policy = data.aws_iam_policy_document.this.json
  tags   = local.tags
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "EnableMetrics"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["cloudwatch:PutMetricData"]
  }
  statement {
    sid       = "EnableLoadBalancing"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["elasticloadbalancing:*"]
  }
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
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
