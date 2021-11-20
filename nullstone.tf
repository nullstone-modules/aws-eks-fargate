terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

data "ns_workspace" "this" {}

data "ns_connection" "network" {
  name = "network"
  type = "network/aws"
}

resource "random_string" "resource_suffix" {
  length  = 5
  lower   = true
  upper   = false
  number  = false
  special = false
}

locals {
  tags               = data.ns_workspace.this.tags
  resource_name      = "${data.ns_workspace.this.block_ref}-${random_string.resource_suffix.result}"
  private_subnet_ids = data.ns_connection.network.outputs.private_subnet_ids
}
