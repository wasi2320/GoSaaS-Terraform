
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "generated_key" {
  key_name   = "${var.client_id}-servers"
  public_key = tls_private_key.my_key.public_key_openssh
}
# Following resource saves PEM File in current directory. Name of PEM file will be [client_id]-servers.pem. 
# Example: client_id variable value : Roche => PEM file name will be Roche-servers.pem
resource "local_file" "ssh_key" {
  filename = "${var.client_id}-servers.pem"
  content = tls_private_key.my_key.private_key_pem
}