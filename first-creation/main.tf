provider "aws" {
region = "ap-south-1"
}

provider "random" {}

resource "random_pet" "name"{}

resource "aws_vpc" "my-vpc"{
  cidr_block = "10.0.0.0/24"
  instance_tenancy = "default"

  tags={
    Name = random_pet.name.id
  }
}

resource "aws_subnet" "my-sub" {
vpc_id = aws_vpc.my-vpc.id
cidr_block = "10.0.0.0/25"
availability_zone = "ap-south-1a"
map_public_ip_on_launch = true

tags={
Name = random_pet.name.id
}
}

	resource "aws_internet_gateway" "my-igw" {
	vpc_id = aws_vpc.my-vpc.id

	tags ={
	Name = random_pet.name.id
		}
	}

resource "aws_route_table" "my-rtb" {
vpc_id = aws_vpc.my-vpc.id

# route {
# cidr_block = "10.0.0.0/24"
# gateway_id = "local"
# }

# route {
# cidr_block = "0.0.0.0/0"
# gateway_id = aws_internet_gateway.my-igw.id
# }

}


resource "aws_route" "l-r"{
route_table_id = aws_route_table.my-rtb.id
destination_cidr_block = "10.0.0.0/24"
gateway_id = "local"
}

resource "aws_route" "g-r" {
route_table_id = aws_route_table.my-rtb.id
destination_cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.my-igw.id
}


resource "aws_route_table_association" "my-rta" {
subnet_id = aws_subnet.my-sub.id
route_table_id = aws_route_table.my-rtb.id
}

resource "aws_security_group" "my-sg" {
name = "my-sg"
description = "JUST TRYING"
vpc_id = aws_vpc.my-vpc.id

tags={
Name = random_pet.name.id
}
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.my-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "outbound" {
  security_group_id = aws_security_group.my-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_instance" "my-ec2" {
ami = "ami-0e35ddab05955cf57"
instance_type = "t2.micro"
subnet_id = aws_subnet.my-sub.id
vpc_security_group_ids = [aws_security_group.my-sg.id]
user_data = file("my-script.sh")

tags={
Name = random_pet.name.id
}
}
