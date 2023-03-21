
resource "aws_vpc" "phonebook-vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "phonebook-vpc-${var.environment}"
  }
}

resource "aws_subnet" "subnet1a" {
  vpc_id                  = aws_vpc.phonebook-vpc.id
  cidr_block              = var.subnet1a_cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = true
  tags = {
    Name = "phonebook-subnet-1a ${var.environment}"
  }
}

resource "aws_subnet" "subnet1b" {
  vpc_id                  = aws_vpc.phonebook-vpc.id
  cidr_block              = var.subnet1b_cidr
  availability_zone       = var.az2
  map_public_ip_on_launch = true
  tags = {
    Name = "phonebook-subnet-1b ${var.environment}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.phonebook-vpc.id
  tags = {
    Name = "igw-phonebook-vpc-${var.environment}"
  }
}
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.phonebook-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-phonebook-vpc-${var.environment}"
  }
}

resource "aws_route_table_association" "as1a" {
  subnet_id      = aws_subnet.subnet1a.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "as1b" {
  subnet_id      = aws_subnet.subnet1b.id
  route_table_id = aws_route_table.rt.id
}