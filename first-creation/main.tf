# AWS Provider
# This provider allows Terraform to interact with AWS services.
# The region is set to ap-south-1 (Mumbai).
provider "aws" {
  region = "ap-south-1"
}

# Random Provider
# This provider is used to generate random values.
# The random pet name is used to create unique names for the resources.
provider "random" {}

# Random Pet Name
# This resource generates a random pet name for tagging resources.
resource "random_pet" "name"{}

# VPC
# A VPC is a virtual network dedicated to your AWS account in a specific region.
resource "aws_vpc" "my-vpc"{
  cidr_block = "10.0.0.0/24"
  instance_tenancy = "default"

  tags={
    Name = random_pet.name.id
  }
}

# Subnet
# A subnet is a range of IP addresses in your VPC.
resource "aws_subnet" "my-sub" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.0.0/25"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true

  tags={
    Name = random_pet.name.id
  }
}

# Internet Gateway
# It is used to allow communication between instances in your VPC and the internet.
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags ={
    Name = random_pet.name.id
  }
}

# Route Table
# This contains a set of rules, called routes,
# that are used to determine where network traffic from your subnet or gateway is directed.
resource "aws_route_table" "my-rtb" {
  vpc_id = aws_vpc.my-vpc.id

  tags={
    Name = random_pet.name.id
  }
}


# This route allows traffic to internet from the subnet using the Internet Gateway.
resource "aws_route" "g-r" {
  route_table_id = aws_route_table.my-rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my-igw.id
}

# Route Table Association
# This associates the route table with the subnet created above.
resource "aws_route_table_association" "my-rta" {
  subnet_id = aws_subnet.my-sub.id
  route_table_id = aws_route_table.my-rtb.id
}

# Security Group
# It allows you to control inbound and outbound traffic to your instances.
# The security group is associated with the VPC created above.
resource "aws_security_group" "my-sg" {
  name = "my-sg"
  description = "JUST TRYING"
  vpc_id = aws_vpc.my-vpc.id

  tags={
    Name = random_pet.name.id
  }
}

# HTTPS Inbound
# This rule allows HTTPS traffic from any IPv4 address to the security group.
resource "aws_vpc_security_group_ingress_rule" "inbound_https" {
  security_group_id = aws_security_group.my-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# SSH Inbound 
# This rule allows HTTP traffic from any IPv4 address to the security group.
resource "aws_vpc_security_group_ingress_rule" "inbound_ssh"{
  security_group_id = aws_security_group.my-sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

# ALL Outbound
# The default behavior of a security group is to allow all outbound traffic.
resource "aws_vpc_security_group_egress_rule" "outbound" {
  security_group_id = aws_security_group.my-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# EC2 Instance
# This resource creates an EC2 instance in the specified subnet and security group.
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
