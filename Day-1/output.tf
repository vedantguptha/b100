output "VpcId" {
  value = aws_vpc.ofl-vpc.id
}


output "VPC-CIDE-BLOCK" {
  value = aws_vpc.ofl-vpc.cidr_block
}