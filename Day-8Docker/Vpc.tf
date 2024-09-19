##################################################################
##                       VPC Creation                           ##
##################################################################
resource "aws_vpc" "ofl-vpc" {
  cidr_block           = var.ofl-cider-range
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
    Name = title("${var.prj_sn}-IGW")
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
    Name = title("${var.prj_sn}-PRT")
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


##################################################################
##                      Private Subnets                        ##
##################################################################

# resource "aws_subnet" "ofl-subnet-private" {
#   count = length(var.ofl-private-subnet-cidr)
#   vpc_id            = aws_vpc.ofl-vpc.id
#   cidr_block        = var.ofl-private-subnet-cidr[count.index]
#   availability_zone = var.ofl_az[count.index]
#   tags = {
#     Name = title("${var.project-name}-VPC-Private-subnet-${count.index+1}")
#   }
# }



##################################################################
##                         EIP Creation                         ##
##################################################################

# resource "aws_eip" "ofl-eip" {
#   domain = "vpc"
#   tags = {
#     Name = title("${var.prj_sn}-EIP")
#   }
# }

##################################################################
##                    NAT Gateway Creation                      ##
##################################################################

# resource "aws_nat_gateway" "ofl-nat" {
#   allocation_id = aws_eip.ofl-eip.id
#   subnet_id     = element(aws_subnet.ofl-subnet-1[*].id, 0)
#   tags = {
#     Name = title("${var.prj_sn}-NAT")
#   }
# }



##################################################################
##                       Private RT                              ##
##################################################################

# resource "aws_route_table" "ofl-private-rt" {
#   vpc_id = aws_vpc.ofl-vpc.id
#   route {
#     cidr_block = var.ofl-open-network
#     gateway_id = aws_nat_gateway.ofl-nat.id
#   }
#   tags = {
#     Name = title("${var.prj_sn}-private-rt")
#   }
# }

##################################################################
##             Private RT Asscioation                          ##
##################################################################

# resource "aws_route_table_association" "accoc-private-subnets" {
#   count = length(var.ofl-public-subnet-cidr)
#   subnet_id = element(aws_subnet.ofl-subnet-private[*].id, count.index)
#   route_table_id = aws_route_table.ofl-private-rt.id
# }
