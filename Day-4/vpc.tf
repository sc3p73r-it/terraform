data "aws_availability_zone" "available" {
    state = "available"
    filter {
      name = "zone-type"
      values = ["availability-zone"]
    }
}
