# Creating VPC
resource "aws_vpc" "demovpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.tags[0]
  }
}

# Creating Internet Gateway and attaching to VPC 
resource "aws_internet_gateway" "demogateway" {
  vpc_id = aws_vpc.demovpc.id
}

# Creating 1st public subnet 
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.demovpc.id
  cidr_block              = var.pub_subnet1_cidr
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"

  tags = {
    Name = var.tags[0]
  }
}

# Creating 2nd public subnet
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.demovpc.id
  cidr_block              = var.pub_subnet2_cidr
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b"

  tags = {
    Name = var.tags[0]
  }
}

# Creating 1st private subnet
resource "aws_subnet" "priv_subnet_1" {
  vpc_id                  = aws_vpc.demovpc.id
  cidr_block              = var.priv_subnet1_cidr
  map_public_ip_on_launch = false
  availability_zone       = "eu-west-2a"

  tags = {
    Name = var.tags[0]
  }
}

# Creating 2nd private subnet
resource "aws_subnet" "priv_subnet_2" {
  vpc_id                  = aws_vpc.demovpc.id
  cidr_block              = var.priv_subnet2_cidr
  map_public_ip_on_launch = false
  availability_zone       = "eu-west-2b"

  tags = {
    Name = var.tags[0]
  }
}

# Creating Public Route Table 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.demovpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demogateway.id
  }

  tags = {
    Name = var.tags[0]
  }
}

# Associating Public Subnet 1 to Public Route Table
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

# Associating Public Subnet 2 to Public Route Table
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}


# Creating Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.demovpc.id
}

# Associating Private Subnet 1 with Private Route Table
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.priv_subnet_1.id
  route_table_id = aws_route_table.private.id
}

# Associating Private Subnet 2  with Private Route Table
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.priv_subnet_2.id
  route_table_id = aws_route_table.private.id
}
# Creating an Elastic IP for pub_sub_1 NAT 
resource "aws_eip" "pub_sub_1" {
  vpc = true
}

# Creating NAT Gateway for pub_sub_1
resource "aws_nat_gateway" "pub_sub_1" {
  allocation_id = aws_eip.pub_sub_1.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = var.tags[0]
  }

  depends_on = [aws_internet_gateway.demogateway]
}

# Creating an Elastic IP for pub_sub_2 NAT Gateway
resource "aws_eip" "pub_sub_2" {
  vpc = true
}

# Creating NAT Gateway for pub_sub_2
resource "aws_nat_gateway" "pub_sub_2" {
  allocation_id = aws_eip.pub_sub_2.id
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = {
    Name = var.tags[0]
  }

  depends_on = [aws_internet_gateway.demogateway]
}
# associating private route table with NAT Gateway
resource "aws_route" "nat_association" {
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.pub_sub_1.id
  destination_cidr_block = "0.0.0.0/0"
}