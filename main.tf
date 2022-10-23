
# Creating VPC
resource "aws_vpc" "demovpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Demo VPC"
  }
}

# Creating Internet Gateway and attaching to VPC 
resource "aws_internet_gateway" "demogateway" {
  vpc_id = aws_vpc.demovpc.id
}

# Creating 1st web subnet 
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.demovpc.id
  cidr_block              = var.pub_subnet1_cidr
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "Web Subnet 1"
  }
}

# Creating 2nd web subnet 
resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = "${aws_vpc.demovpc.id}"
  cidr_block              = var.pub_subnet2_cidr
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b"

  tags = {
    Name = "Web Subnet 2"
  }
}

# Creating 1st application subnet 
resource "aws_subnet" "application-subnet-1" {
  vpc_id                  = "${aws_vpc.demovpc.id}"
  cidr_block              = var.priv_subnet1_cidr
  map_public_ip_on_launch = false
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "Application Subnet 1"
  }
}

# Creating 2nd application subnet 
resource "aws_subnet" "application-subnet-2" {
  vpc_id                  = "${aws_vpc.demovpc.id}"
  cidr_block              = var.priv_subnet2_cidr
  map_public_ip_on_launch = false
  availability_zone       = "eu-west-2b"

  tags = {
    Name = "Application Subnet 2"
  }
}

# Creating Public Route Table
resource "aws_route_table" "pub_route" {
  vpc_id = "${aws_vpc.demovpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.demogateway.id}"
  }

  tags = {
    Name = "Route to internet"
  }
}

# Associating Public Subnets to Public Route Table
resource "aws_route_table_association" "ps-prt" {
  subnet_id      = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
  route_table_id = var.aws_route_table.pub_route.id
  }

# Creating Private Route Table
resource "aws_route_table" "priv_route" {
  vpc_id = "${aws_vpc.demovpc.id}"
}
# Associating Private Subnets to Private Route Table
resource "aws_route_table_association" "rt1" {
  subnet_id      = [aws_subnet.application-subnet-1.id, aws_subnet.application-subnet-2.id]
  route_table_id = var.aws_route_table_priv_route.id
}

