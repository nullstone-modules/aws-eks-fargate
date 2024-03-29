output "cluster_logs_group" {
  value       = module.logs.name
  description = "string ||| The name of the Cloudwatch log group containing EKS Control Plane logs."
}

output "cluster_arn" {
  value       = aws_eks_cluster.this.arn
  description = "string ||| AWS Arn for EKS Fargate cluster."
}

output "cluster_name" {
  value       = aws_eks_cluster.this.name
  description = "string ||| Name of the EKS Fargate cluster."
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.this.endpoint
  description = "string ||| Endpoint address for EKS Fargate cluster."
}

output "cluster_ca_certificate" {
  value       = aws_eks_cluster.this.certificate_authority[0].data
  description = "string ||| Base64-encoded certificate to connect to cluster."
}

output "fargate_namespace" {
  value       = "default"
  description = "string ||| Namespace selector for default fargate profile."
}

output "cluster_openid_provider_arn" {
  value       = aws_iam_openid_connect_provider.this.arn
  description = "string ||| ARN of the OpenID Connect Provider that is used to provide IAM roles with Kubernetes Service Accounts"
}

output "node_security_group_id" {
  value       = aws_security_group.node.id
  description = "string ||| ID of the Security Group that is applied to each node in the EKS cluster. This limits traffic inside the network."
}
