# data "aws_availability_zones" "available" {
#   state = "available"
#   filter {
#     name   = "zone-type"
#     values = ["availability-zone"]
#   }
# }

resource "aws_vpc" "base_vpc" {
  cidr_block = var.base_vpc.cidr // 10.0.0.0/16
  tags = {
    Name = var.base_vpc.Name // VPC-A
  }
}

resource "aws_internet_gateway" "base_igw" {
  vpc_id = aws_vpc.base_vpc.id
  tags = {
    Name = "base_igw" // VPC-A-IGW
  }
}


// count
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets) //list
  vpc_id                  = aws_vpc.base_vpc.id
  cidr_block              = var.public_subnets[count.index].cidr // 10.0.0.0/24
  map_public_ip_on_launch = true
  availability_zone       = var.public_subnets[count.index].zone // ap-southeast-1
  tags = {
    Name = "${local.vpc_name}-${var.public_subnets[count.index].Name}" // VPC-A-Public-1
  }
}

// for each
# resource "aws_subnet" "public_subnets" {
#   for_each = aws_subnets.public_subnets
#   vpc_id                  = aws_vpc.base_vpc.id
#   cidr_block              = each.value.cidr  // 10.0.0.0/24
#   map_public_ip_on_launch = true
#   availability_zone       = each.value.zone // ap-southeast-1
#   tags = {
#     Name = "${local.vpc_name}-${each.value.name}" // VPC-A-Public-1
#   }
# }

# resource "local_file" "hello" {
#   filename = "./hello.txt"
#   content  = var.hello["myanmar"]

# }

# output "hello" {
#   value = local_file.hello.content

# }

locals {
  vpc_name = aws_vpc.base_vpc.tags.Name
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.base_vpc.id
  tags = {
    Name = "${local.vpc_name}-Public-RTB"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.base_igw.id
  }
  
}

resource "aws_route_table_association" "public_rtb_association" {
  count = length(var.public_subnets)
  route_table_id = aws_route_table.public_rtb.id
  subnet_id =  aws_subnet.public_subnets[count.index].id
}