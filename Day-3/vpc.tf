// Create VPC
// Create Internet Gateway
// Attach Internet Gateway to VPC
// Create on public subnet per each zone
// Create on public routing tables and associate it with all public subnets.

# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "tf_vpc" {
  cidr_block = var.my_vpc_cidr
  tags = {
    Name = var.my_vpc_name
  }
}

// IGW
resource "aws_internet_gateway" "tf_igw" {
  tags = {
    Name = "my_igw"
  }
}

resource "aws_internet_gateway_attachment" "tf_igw" {
  internet_gateway_id = aws_internet_gateway.tf_igw.id
  vpc_id              = aws_vpc.tf_vpc.id
}

// Default Route Table
resource "aws_route_table" "tf_pub_rtb" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = var.my_route_tb
    gateway_id = aws_internet_gateway.tf_igw.id
  }

  tags = {
    Name = "my_public_rtb"
  }
}

// subnet
resource "aws_subnet" "my_pub_subnets" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.tf_vpc.id
  availability_zone = var.zone_for_subnets[count.index]
  cidr_block        = var.zone_for_cidr[count.index]
  tags = {
    Name = var.name_for_subnets[count.index]
  }
}

# resource "aws_subnet" "tf_subnet2" {
#     vpc_id = aws_vpc.tf_vpc.id
#     availability_zone = "ap-southeast-1b"
#     cidr_block = var.my_subnet_02
#     tags = {
#       Name = "my_subnet2"
#     }
# }

# resource "aws_subnet" "tf_subnet3" {
#     vpc_id = aws_vpc.tf_vpc.id
#     availability_zone = "ap-southeast-1c"
#     cidr_block = var.my_subnet_03
#     tags = {
#       Name = "my_subnet3"
#     }
# }

// routetable association
resource "aws_route_table_association" "pub_rtb_subnets" {
  count = length(aws_subnet.my_pub_subnets)
  subnet_id      = aws_subnet.my_pub_subnets[count.index].id
  route_table_id = aws_route_table.tf_pub_rtb.id
}

# resource "aws_route_table_association" "pub_rtb_subnets" {
#   subnet_id      = aws_subnet.tf_subnet2[1]
#   route_table_id = aws_route_table.tf_pub_rtb.id
# }

# resource "aws_route_table_association" "pub_rtb_subnets" {
#   subnet_id      = aws_subnet.tf_subnet3[2]
#   route_table_id = aws_route_table.tf_pub_rtb.id
# }