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
