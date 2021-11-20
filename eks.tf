resource "aws_eks_cluster" "this" {
  name     = local.resource_name
  role_arn = aws_iam_role.this.arn

  vpc_config {
    subnet_ids = local.private_subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.this_policy,
    aws_iam_role_policy_attachment.this_vpc_resource_controller,
  ]
}
