#vpc
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr

  azs =  var.availablity

  public_subnets = var.subnet


  enable_dns_hostnames = true
  map_public_ip_on_launch = true

  tags = {
    Name        = "myvpc"
    Terraform   = "true"
    Environment = "dev"
  }
  public_subnet_tags = {
    Name = "subnetjenkin"
  }
}




#sg

module "vote_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkin-sg"
  description = "Security group"
  vpc_id      = module.vpc.vpc_id


  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    Name = "jenkins-sg"
  }
}


#ec2
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type               = var.intance-type
  key_name                    = "vishal"
  monitoring                  = true
  vpc_security_group_ids      = [module.vote_service_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("jenkin.install.sh")
  availability_zone           = "ap-south-1a"

  tags = {
    Name        = "jenkin-server"
    Terraform   = "true"
    Environment = "dev"
  }
}