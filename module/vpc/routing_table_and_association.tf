# Private subnets route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.client_id}-private-route-table"
    Environment = var.env
  }
}

# Public subnets route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.client_id}-public-route-table"
    Environment = var.env
  }
}

#Associate the public route table to public subnets                
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Associate the public route table to public subnets
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.route_table_private.id
}

# Add route for public route table to internet gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
  depends_on             = [aws_internet_gateway.ig]
}
# Add route for private route table to nat gateway

resource "aws_route_table" "route_table_private"{
  vpc_id           = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  route {                                  # route for VPN connection
    cidr_block = "172.31.90.192/32"        
    vpc_peering_connection_id = aws_vpc_peering_connection.gosaas-vpc-peering.id
  }
  route {                                  # route for zabbix agent connection
    cidr_block = "172.31.12.157/32"       
    vpc_peering_connection_id = aws_vpc_peering_connection.gosaas-vpc-peering.id
  }
  tags = {
    Name           = "${var.client_id}-private-route-table"
  }
}

