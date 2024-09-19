resource "aws_instance" "webserver2" {
  ami = "ami-022ce6f32988af5fa"
  instance_type = "t3.micro"
  tags = {
    Name = title("${terraform.workspace}-Webserver")
  }
}