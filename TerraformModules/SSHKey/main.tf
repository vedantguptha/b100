##################################################################
##                   SSH Key Generation                         ##
##################################################################
resource "tls_private_key" "ofl-key" {
  algorithm = var.ofl-algorithm
  rsa_bits  = var.ofl-rsa_bits
}
##################################################################
##                  AWS Key Pair Creation                       ##
##################################################################

resource "aws_key_pair" "ofl-key-pair" {
  key_name = "${var.ofl-prj_sn}-ssh-key"
  public_key = tls_private_key.ofl-key.public_key_openssh
}

##################################################################
##                   .Pem file Creation                         ##
##################################################################
resource "local_file" "key-file" {
  filename = "${aws_key_pair.ofl-key-pair.key_name}.pem"
  content = tls_private_key.ofl-key.private_key_openssh
  file_permission = var.ofl-file_permission
}