resource "aws_eks_fargate_profile" "this" {
  cluster_name           = aws_eks_cluster.this.name
  fargate_profile_name   = local.resource_name
  pod_execution_role_arn = aws_iam_role.fargate.arn
  subnet_ids             = local.private_subnet_ids
  tags                   = local.tags

  selector {
    namespace = "default"
  }
}

resource "aws_iam_role" "fargate" {
  name               = "${local.resource_name}-fargate"
  assume_role_policy = data.aws_iam_policy_document.fargate.json
  tags               = local.tags
}

data "aws_iam_policy_document" "fargate" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "fargate_pod_execution" {
  role       = aws_iam_role.fargate.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

