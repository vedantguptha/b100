output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.ofl-vpc.id
}

output "public_subnets" {
  description = "List of IDs of Public subnets"
  value       = aws_subnet.ofl-public-subnet[*].id
}


output "private_subnets" {
  description = "List of IDs of private subnets"
  value = try(aws_subnet.ofl-private-subnet[*].id, null )
}