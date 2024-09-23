data "aws_availability_zones" "available" {
  state = "available"
}

output "my_zones" {
  value = data.aws_availability_zones.available.names
}

output "name" {
  value = "My VPC is id is ${aws_vpc.base_vpc.id}." // interpolation
}