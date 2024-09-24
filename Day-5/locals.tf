locals {
  vpc_name     = aws_vpc.base_vpc.tags.Name
  any_protocol = "-1"
  any_where    = "0.0.0.0/0"
  ssh          = "22"
}
