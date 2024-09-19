# module "vpc" {
#   source = "../TerraformModules/VPC/Test"
#   name = "ofl- ${terraform.workspace}"
#   cidr_block = "10.0.0.0/16"
  
#   public_subnets_name = ["Jumphost", "webserver"]
#   azs = ["ap-south-1a", "ap-south-1b"]
#   public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
#   private-subnet = ["10.0.1.0/24", "10.0.2.0/24"]
#   enable_dns_hostnames = true
#   enable_dns_support = true
#   enable_private = false
#   tags = {
#     Creator = "Terraform"
#   }
# }