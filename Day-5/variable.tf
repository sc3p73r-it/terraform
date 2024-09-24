variable "base_vpc" {
  type = object({
    Name = string
    cidr = string
  })

  default = {
    Name = "VPC-A"
    cidr = "10.0.0.0/16"
  }

}

// subnet
variable "public_subnets" {
  type = list(object({
    Name = string
    cidr = string
    zone = string
  }))

  default = [
    {
      Name = "public_Subnet_1"
      cidr = "10.0.0.0/24"
      zone = "ap-southeast-1a"
    },
    {
      Name = "public_Subnet_2"
      cidr = "10.0.1.0/24"
      zone = "ap-southeast-1b"
    },
    {
      Name = "public_Subnet_3"
      cidr = "10.0.2.0/24"
      zone = "ap-southeast-1c"
    }
  ]
}


# variable "hello" {
#   type = map(object)
#   default = {
#     "myanmar" = {}
#     "english" = {}

#   }

# }