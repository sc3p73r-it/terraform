resource "aws_instance" "web01" {
  ami = "ami-01811d4912b4ccb26"
  instance_type = "t2.micro"
   tags = {
     Name = "Web Server"
   }
}

resource "local_file" "name" {
  filename = ""
  content = ""
}