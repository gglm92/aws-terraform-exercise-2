resource "aws_vpc" "vpc"{
    cidr_block           = var.vpc_cidr_block
    enable_dns_hostnames = "true"
    tags = {
        IaC = "Terraform",
        env = var.environment,
        Name = "VPC exercise 2"
    }
}

resource "aws_subnet" "private-subnet-1" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.private_subnet_1_cidr_block
    availability_zone = var.availability_zone_1
    tags = {
        IaC = "Terraform",
        env = var.environment,
        Name = "Private subnet 1"
    }
}

resource "aws_subnet" "private-subnet-2" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.private_subnet_2_cidr_block
    availability_zone = var.availability_zone_2
    tags = {
        IaC = "Terraform",
        env = var.environment,
        Name = "Private subnet 2"
    }
}

resource "aws_subnet" "public-subnet-1" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.public_subnet_1_cidr_block
    availability_zone = var.availability_zone_1
    tags = {
        IaC = "Terraform",
        env = var.environment,
        Name = "Public subnet 1"
    }
}

resource "aws_subnet" "public-subnet-2" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.public_subnet_2_cidr_block
    availability_zone = var.availability_zone_2
    tags = {
        IaC = "Terraform",
        env = var.environment,
        Name = "Public subnet 2"
    }
}

resource "aws_security_group" "allow-http" {
    name        = "allow_http"
    description = "Allow HTTP inbound connections"
    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Allow HTTP Security Group"
    }
}

resource "aws_subnet" "subnet-bastion" {
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = "13.0.7.0/24"
    availability_zone = "us-east-1c"
    tags = {
        Name = "Bastion Subnet"
    }
}

resource "aws_internet_gateway" "igw-bastion" {
    vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "route-table-public"{
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw-bastion.id
    }
    tags = {
        Name = "Route table to Bastion"
    }
}

resource "aws_route_table_association" "route-table-with-vpc" {
    subnet_id         = aws_subnet.subnet-bastion.id
    route_table_id    = aws_route_table.route-table-public.id
}

resource "aws_eip" "elastic-ip" {
    instance = aws_instance.bastion.id
    vpc = true
}

resource "aws_security_group" "sg-bastion" {
  name        = "bastion"
  description = "bastion"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-bastion"
  }
}

resource "aws_instance" "bastion" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  associate_public_ip_address = "true"
  subnet_id                   = aws_subnet.subnet-bastion.id
  vpc_security_group_ids      = [aws_security_group.sg-bastion.id]
  key_name                    = var.key_name
  tags = {
    type = "bastion"
  }
}