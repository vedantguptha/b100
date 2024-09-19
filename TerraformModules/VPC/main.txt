##################################################################
##                       VPC Creation                           ##
##################################################################
resource "aws_vpc" "ofl-vpc" {
  cidr_block           = var.ofl-cidr-range
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = title("${var.project-name}-VPC")
  }
}



##################################################################
##                   Public Subnet - 1                         ##
##################################################################

resource "aws_subnet" "ofl-subnet-1" {
  count = length(var.ofl-public-subnet-cidr)
  vpc_id            = aws_vpc.ofl-vpc.id
  cidr_block        = var.ofl-public-subnet-cidr[count.index]
  availability_zone = var.ofl_az[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = title("${var.project-name}-VPC-Public-subnet-${count.index+1}")
  }
}


##################################################################
##                       IGW Creation                           ##
##################################################################

resource "aws_internet_gateway" "ofl-igw" {
  vpc_id = aws_vpc.ofl-vpc.id
  tags = {
    Name = title("${var.project-name}-IGW")
  }
}


##################################################################
##                       Public RT                              ##
##################################################################

resource "aws_route_table" "ofl-prt" {
  vpc_id = aws_vpc.ofl-vpc.id
  route {
    cidr_block = var.ofl-open-network
    gateway_id = aws_internet_gateway.ofl-igw.id
  }
  tags = {
    Name = title("${var.project-name}-PRT")
  }
}

##################################################################
##                      RT Asscioation                          ##
##################################################################

resource "aws_route_table_association" "accoc-public-subnets" {
  count = length(var.ofl-public-subnet-cidr)
  subnet_id = element(aws_subnet.ofl-subnet-1[*].id, count.index)
  route_table_id = aws_route_table.ofl-prt.id
}

