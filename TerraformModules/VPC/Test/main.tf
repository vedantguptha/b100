##################################################################
##                       VPC Creation                           ##
##################################################################
resource "aws_vpc" "ofl-vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
   tags = merge(
    { "Name" = title(var.name) },
    var.tags,
    var.vpc_tags,
  )
}

#################################################################
#                 Public Subnets Creation                      ##
#################################################################
resource "aws_subnet" "ofl-public-subnet" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.ofl-vpc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    { "Name"    = title("${var.name}-${var.public_subnets_name[count.index]}") },
    var.tags,
    var.vpc_tags,
  )
}

################################################################
##                      IGW Creation                           ##
################################################################
resource "aws_internet_gateway" "ofl-igw" {
  vpc_id = aws_vpc.ofl-vpc.id
  tags = merge(
    { "Name" = title("${var.name}-IGW")  },
    var.tags,
    var.vpc_tags,
  )
  depends_on = [aws_vpc.ofl-vpc]
}

#################################################################
#                 Public Route Table                           ##
#################################################################
resource "aws_route_table" "ofl-public-route-table" {
  vpc_id = aws_vpc.ofl-vpc.id
  route {
    cidr_block = var.internet-cidr
    gateway_id = aws_internet_gateway.ofl-igw.id
  }
  tags = merge(
    { "Name" = title("${var.name}-Public Route Table") },
    var.tags,
    var.vpc_tags,
  )
  depends_on = [aws_vpc.ofl-vpc, aws_subnet.ofl-public-subnet]
}

#################################################################
#    Public Route Table Asscioation with Public Subnets        ##
#################################################################
resource "aws_route_table_association" "ofl-public-subnet-asscioations" {
  count          = length(var.azs)
  subnet_id      = element(aws_subnet.ofl-public-subnet[*].id, count.index)
  route_table_id = aws_route_table.ofl-public-route-table.id
}


#################################################################
#                 Private Subnets Creation                      ##
#################################################################
resource "aws_subnet" "ofl-private-subnet" {
  count                   = var.enable_private ? length(var.azs) : 0
  vpc_id                  = aws_vpc.ofl-vpc.id
  cidr_block              = var.private-subnet[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    { Name    = title("${var.name}-private-Subnet-${count.index + 1}") },
    var.tags,
    var.vpc_tags,
  )
}


##################################################################
##                         EIP Creation                         ##
##################################################################
resource "aws_eip" "ofl-eip" {
count                   = var.enable_private ? 1 : 0
  domain = "vpc"
  tags = merge(
    { Name    = title("${var.name}-eip}") },
    var.tags,
    var.vpc_tags,
  )
}
##################################################################
##                    NAT Gateway Creation                      ##
##################################################################
resource "aws_nat_gateway" "ofl-nat" {
count = var.enable_private ? 1 : 0
  allocation_id = aws_eip.ofl-eip[0].id
  subnet_id     = aws_subnet.ofl-private-subnet[0].id
  tags = merge(
    { Name    = title("${var.name}-Nat}") },
    var.tags,
    var.vpc_tags,
  )
  depends_on = [aws_internet_gateway.ofl-igw]
}
##################################################################
##                 Private Route Table                           ##
##################################################################
resource "aws_route_table" "ofl-private-route-table" {
  count                   = var.enable_private ? 1 : 0
  vpc_id = aws_vpc.ofl-vpc.id
  route {
    cidr_block = var.internet-cidr
    gateway_id = aws_nat_gateway.ofl-nat[0].id
  }
  tags = merge(
    { "Name" = title("${var.name}-Private Route Table") },
    var.tags,
    var.vpc_tags,
  )
}
##################################################################
##    Private Route Table Asscioation with Private Subnets      ##
##################################################################
resource "aws_route_table_association" "ofl-private-subnet-asscioations" {
  count          = var.enable_private ? length(var.azs) : 0
  subnet_id      = element(aws_subnet.ofl-private-subnet[*].id, count.index)
  route_table_id = aws_route_table.ofl-private-route-table[0].id
}