resource "aws_instance" "docker" {
  ami = "ami-022ce6f32988af5fa" 
  instance_type = "t2.micro"
  tags = {
    Name = "${var.prj_sn}-Docker"
  }
  subnet_id = element(aws_subnet.ofl-subnet-1[*].id, 1)
  key_name = aws_key_pair.ofl-key-pair.key_name
  vpc_security_group_ids = [ aws_security_group.ofl-alow-ssh.id, aws_security_group.ofl-webserver-sg.id  ]
 lifecycle {
    create_before_destroy = true
  }

provisioner "remote-exec" {
  inline = [ 
    "sudo yum install -y yum-utils",
    "sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo",
    "sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y",
    "sudo systemctl start docker",
    "systemctl enable docker.service",
    "systemctl status docker.service --no-pager"
   ]
   connection {
     type = "ssh"
     user = "ec2-user"
     host = aws_instance.docker.public_ip
     private_key = file("./${aws_key_pair.ofl-key-pair.key_name}.pem")
   }
}
 
}