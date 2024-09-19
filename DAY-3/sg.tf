resource "aws_security_group" "ofl-alow-ssh" {
  name = "${var.prj_sn}-allow-ssh-sg"
  vpc_id = aws_vpc.ofl-vpc.id
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ var.ofl-open-network ] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ var.ofl-open-network ]
  }
  #  lifecycle {
  #   prevent_destroy = true
  # }
}

# 80,8080, 443
resource "aws_security_group" "ofl-webserver-sg" {
  name = "${var.prj_sn}-weebservers-sg"
  vpc_id = aws_vpc.ofl-vpc.id

  dynamic "ingress" {
    for_each = var.inbound-port-numbers
    content {
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = [ var.ofl-open-network ] 
    }
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ var.ofl-open-network ]
  }
#    lifecycle {
#     prevent_destroy = true
#   }
}