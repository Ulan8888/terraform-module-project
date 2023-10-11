provider aws {
    region = var.region
}
resource "aws_vpc" "group2" {
  cidr_block  =   var.vpc_cidr
  tags = {
    Name = "group2"
  }
}
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.group2.id
  cidr_block = var.subnet_cidr1
  availability_zone = var.az1
  map_public_ip_on_launch = var.ip_on_launch
  tags = {
    Name = "Group2"
  }
}
resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.group2.id
  cidr_block = var.subnet_cidr2
  availability_zone = var.az2
  map_public_ip_on_launch = var.ip_on_launch
  tags = {
    Name = "Group2"
  }
}
resource "aws_subnet" "subnet3" {
  vpc_id     = aws_vpc.group2.id
  cidr_block = var.subnet_cidr3
  availability_zone = var.az3
  map_public_ip_on_launch = var.ip_on_launch
  tags = {
    Name = "Group2"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.group2.id
  tags = {
    Name = "group2"
  }
}
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.group2.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "group2"
  }
}
resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.example.id
}
resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.example.id
}
resource "aws_route_table_association" "a3" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.example.id
}