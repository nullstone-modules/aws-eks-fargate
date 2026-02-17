resource "aws_iam_role" "this" {
  name               = local.resource_name
  assume_role_policy = data.aws_iam_policy_document.this_assume.json
  tags               = local.tags
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
