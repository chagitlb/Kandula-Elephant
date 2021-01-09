module "vpc" {
  source       = "./NetworkModule"
  name         = "opsschool-vpc"
  cidr_vpc   = var.cidr_vpc
  azs          = var.availability_zones
  cidr_public  = var.cidr_public
  cidr_private = var.cidr_private
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  
  # tags = {
  #   "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  # }
}

locals {
  cluster_name = "opsschool-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}
