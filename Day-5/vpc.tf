# module "ofl-vpc" {
#   source         = "./module/VPC"
#   ofl-cidr-range = "10.17.0.0/24"
#   project-name   = "ofl-devops-vpc"
#   ofl-public-subnet-cidr = ["10.17.0.0/26", "10.17.0.64/26" ] 
#   ofl_az = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
#   ofl-open-network = "0.0.0.0/0"
# }

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}



module "aws-key-pair" {
  source              = "./module/SSHKey"
  ofl-algorithm       = "RSA"
  ofl-rsa_bits        = 4096
  ofl-file_permission = "0400"
  ofl-prj_sn          = "Devops"
}





# output "aws_key_pair_name" {
#   value = module.aws-key-pair.ofl-key-name
# }