module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr

  azs = data.aws_availability_zones.az.names

  public_subnets = var.subnet

  private_subnets = var.private_subnets

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/elb"               = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"      = 1
  }

}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "myekscluster"
  cluster_version = "1.24"

  cluster_endpoint_public_access = true


  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets




  eks_managed_node_groups = {
    nodes = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups

      instance_types = ["t2.micro"]

      min_size     = 2
      max_size     = 10
      desired_size = 2
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator


  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
