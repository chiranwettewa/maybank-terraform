resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}

data "aws_availability_zones" "available_zones" {
    state = "available"
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public_subnet_a"
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_a_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]

  tags      = {
    Name    = "private_subnet_a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public_subnet_b"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_b_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]

  tags = {
    Name = "private_subnet_b"
  }
}

resource "aws_nat_gateway" "NAT_gw_a" {
  allocation_id = aws_eip.eip_a.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "NAT_gw_a"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "NAT_gw_b" {
  allocation_id = aws_eip.eip_b.id
  subnet_id     = aws_subnet.public_subnet_b.id

  tags = {
    Name = "NAT_gw_b"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "eip_a" {
  tags = {
    Name = "nat_eip_a"
  }
}

resource "aws_eip" "eip_b" {
  tags = {
    Name = "nat_eip_b"
  }
}

resource "aws_route_table" "public_subnets_both" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}

resource "aws_route_table_association" "rt_association_public_a" {
  
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_subnets_both.id
}

resource "aws_route_table_association" "rt_association_public_b" {
  
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_subnets_both.id
}


resource "aws_route_table" "rt_private_subnet_a" {

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_gw_a.id
  }

}

resource "aws_route_table" "rt_private_subnet_b" {

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_gw_b.id
  }

}

resource "aws_route_table_association" "rt_association_private_a" {
 
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.rt_private_subnet_b.id
}

resource "aws_route_table_association" "rt_association_private_b" {
 
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.rt_private_subnet_b.id
}