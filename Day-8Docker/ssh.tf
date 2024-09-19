
##################################################################
##                   SSH Key Generation                         ##
##################################################################
resource "tls_private_key" "ofl-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
##################################################################
##                  AWS Key Pair Creation                       ##
##################################################################

resource "aws_key_pair" "ofl-key-pair" {
  key_name = "${var.prj_sn}-ssh-key"
  public_key = tls_private_key.ofl-key.public_key_openssh
}

##################################################################
##                   .Pem file Creation                         ##
##################################################################
resource "local_file" "key-file" {
  filename = "${aws_key_pair.ofl-key-pair.key_name}.pem"
  content = tls_private_key.ofl-key.private_key_openssh
  file_permission = "0400"
}