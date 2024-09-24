resource "aws_nat_gateway" "my_natgw" {
  allocation_id = aws_eip.my_natgw_eip.id
  subnet_id     = aws_subnet.public_subnets[1].id

  tags = {
    Name = "MY NAT Gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.base_igw]
}

resource "aws_eip" "my_natgw_eip" {
  domain = "vpc"

}