resource "aws_vpc_peering_connection" "gosaas-vpc-peering" {
  peer_vpc_id   = "vpc-830882f9"
  peer_owner_id = "101380220521"
  vpc_id        = aws_vpc.vpc.id
  peer_region   = "us-east-1"
  tags = {
    Name        = "gosaas-${var.client_id}"
    Description = "peering for accessing private resources via gosaas vpn"
  }
}