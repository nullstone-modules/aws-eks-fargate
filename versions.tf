terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    ns = {
      source  = "nullstone-io/ns"
      version = "~> 0.8"
    }
  }
}
