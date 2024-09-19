resource "aws_instance" "ans-master" {
  ami = "ami-022ce6f32988af5fa" 
  instance_type = "t2.micro"
  tags = {
    Name = "${var.prj_sn}-Ansible-Master"
  }
  subnet_id = element(aws_subnet.ofl-subnet-1[*].id, 1)
  key_name = aws_key_pair.ofl-key-pair.key_name
  vpc_security_group_ids = [ aws_security_group.ofl-alow-ssh.id, aws_security_group.ofl-webserver-sg.id  ]
 lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "ans-node" {
  ami = "ami-022ce6f32988af5fa" 
  instance_type = "t2.micro"
  tags = {
    Name = "${var.prj_sn}-Ansible-Node"
  }
  subnet_id = element(aws_subnet.ofl-subnet-1[*].id, 1)
  key_name = aws_key_pair.ofl-key-pair.key_name
  vpc_security_group_ids = [ aws_security_group.ofl-alow-ssh.id, aws_security_group.ofl-webserver-sg.id  ]
 lifecycle {
    create_before_destroy = true
  }
}




resource "aws_instance" "ans-node-1" {
  ami = "ami-022ce6f32988af5fa" 
  instance_type = "t2.micro"
  tags = {
    Name = "${var.prj_sn}-Ansible-Node-2"
  }
  subnet_id = element(aws_subnet.ofl-subnet-1[*].id, 1)
  key_name = aws_key_pair.ofl-key-pair.key_name
  vpc_security_group_ids = [ aws_security_group.ofl-alow-ssh.id, aws_security_group.ofl-webserver-sg.id  ]
 lifecycle {
    create_before_destroy = true
  }
}


# resource "aws_instance" "instance" {
#   for_each      = toset(["ans-node-1" ])
#   ami = "ami-048fecf7f93a5bc2e" 
#   instance_type = "t2.micro"
#   tags = {
#     Name = "${var.prj_sn}-Ans-Node-${each.key}"
#   }
#   subnet_id = element(aws_subnet.ofl-subnet-1[*].id, 1)
#   key_name = aws_key_pair.ofl-key-pair.key_name
#   vpc_security_group_ids = [ aws_security_group.ofl-alow-ssh.id, aws_security_group.ofl-webserver-sg.id  ]
# }





# resource "local_file" "inventory" {
#   content = templatefile("inventory.tmpl", { content = tomap({
#     for instance in aws_instance.instance:
#       instance.tags.Name => instance.public_dns
#     })
#   })
#   filename = format("%s/%s", abspath(path.root), "inventory.yaml")
# }