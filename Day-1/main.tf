provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "webserver" {
  ami           = var.ofl-ami
  instance_type = var.ofl-instance_type
  tags = {
    Name    = "Webserver"
    Creator = "Terraform"
  }
}

##################################################################
##                       VPC Creation                           ##
##################################################################

resource "aws_vpc" "ofl-vpc" {
  cidr_block = var.ofl-cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "My-Devops-VPC"
  }
}

##################################################################
##                   Public Subnet - 1                         ##
##################################################################

resource "aws_subnet" "ofl-subnet-1" {
  vpc_id = aws_vpc.ofl-vpc.id
  cidr_block = "10.17.0.0/26"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "Public-Subnet-1"
  }
}