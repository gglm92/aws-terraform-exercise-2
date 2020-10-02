resource "aws_route_table" "rt-public-nat1"{
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-bastion.id
  }
  tags = {
    Name = "Route Table public NAT 1"
  }
}

resource "aws_route_table" "rt-public-nat2"{
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-bastion.id
  }
  tags = {
    Name = "Route Table public NAT 2"
  }
}


resource "aws_route_table_association" "route-table-public-nat1" {
  subnet_id         = aws_subnet.public-subnet-1.id
  route_table_id    = aws_route_table.rt-public-nat1.id
}


resource "aws_route_table_association" "route-table-public-nat2" {
  subnet_id         = aws_subnet.public-subnet-2.id
  route_table_id    = aws_route_table.rt-public-nat1.id
}

resource "aws_eip" "elastic-ip-nat1" {
    vpc = true
}

resource "aws_eip" "elastic-ip-nat2" {
    vpc = true
}

resource "aws_nat_gateway" "nat_gateway_1" {
    allocation_id = aws_eip.elastic-ip-nat1.id
    subnet_id = aws_subnet.public-subnet-1.id
    depends_on = [aws_internet_gateway.igw-bastion]
}

resource "aws_nat_gateway" "nat_gateway_2" {
    allocation_id = aws_eip.elastic-ip-nat2.id
    subnet_id = aws_subnet.public-subnet-1.id
    depends_on = [aws_internet_gateway.igw-bastion]
}

resource "aws_route_table" "rt-private-nat1"{
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_1.id
  }
  tags = {
    Name = "Route table to NAT 1"
  }
}

resource "aws_route_table" "rt-private-nat2"{
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_2.id
  }
  tags = {
    Name = "Route table to NAT 2"
  }
}

resource "aws_route_table_association" "rta-private-1a" {
    subnet_id = aws_subnet.private-subnet-1.id
    route_table_id = aws_route_table.rt-private-nat1.id
}

resource "aws_route_table_association" "rta-private-1b" {
    subnet_id = aws_subnet.private-subnet-2.id
    route_table_id = aws_route_table.rt-private-nat2.id
}