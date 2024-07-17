# Create a Virtual Private Cloud (VPC)
resource "aws_vpc" "main" {
    cidr_block = var.aws_vpc_cidr_block
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.app_name}-main-vpc"
    }
}

# Create a public subnet
resource "aws_subnet" "public" {
    vpc_id     = aws_vpc.main.id
    cidr_block = var.aws_public_subnet_cidr_block
    map_public_ip_on_launch = true
    availability_zone = "us-west-2a"

    tags = {
        Name = "${var.app_name}-public-subnet"
    }
}

# Create a private subnet
resource "aws_subnet" "private" {
    vpc_id     = aws_vpc.main.id
    cidr_block = var.aws_private_subnet_cidr_block
    availability_zone = "us-west-2b"

    tags = {
        Name = "${var.app_name}-private-subnet"
    }
}

# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.app_name}-main-internet-gateway"
    }
}

# Create a NAT Gateway for the VPC
resource "aws_eip" "nat" {
    domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.public.id

    tags = {
        Name = "${var.app_name}-main-nat-gateway"
    }
}

# Create a public route table for the VPC
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    tags = {
        Name = "${var.app_name}-public-route-table"
    }
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

# Create a private route table for the VPC
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block    = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }

    tags = {
        Name = "${var.app_name}-private-route-table"
    }
}

# Associate the private subnet with the private route table
resource "aws_route_table_association" "private" {
    subnet_id      = aws_subnet.private.id
    route_table_id = aws_route_table.private.id
}