output "PublicIP" {
  value = aws_instance.docker.public_ip
}


output "ssh-command" {
  value = "ssh -i ${aws_key_pair.ofl-key-pair.key_name}.pem ec2-user@${aws_instance.docker.public_dns}"
}

