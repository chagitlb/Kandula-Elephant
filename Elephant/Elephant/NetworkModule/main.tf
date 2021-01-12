terraform {
  required_version = ">= 0.13"
}
/*
  vpc
*/
resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_vpc
    enable_dns_hostnames = true
    tags = var.tags
}

/*
  Public Subnet
*/
resource "aws_subnet" "public-subnet" {
    count = length(var.cidr_public)
    vpc_id = aws_vpc.vpc.id

    cidr_block = var.cidr_public[count.index]
    availability_zone = var.azs[count.index]
    map_public_ip_on_launch = true
    tags = var.public_subnet_tags
    
}

resource "aws_route_table" "public-route" {
    vpc_id = aws_vpc.vpc.id

    route {
        gateway_id = aws_internet_gateway.default.id
        cidr_block = "0.0.0.0/0"
    }


    tags ={
        Name = "Public Route Table - ${var.name}"
    }
}

resource "aws_route_table_association" "public-association" {
    count = length(aws_route_table.public-subnet.*.id) 
    subnet_id = aws_subnet.public-subnet[count.index].id
    route_table_id = aws_route_table.public-route.id
}
/*
  Private Subnet
*/
resource "aws_subnet" "private-subnet" {
    count = length(var.cidr_private)
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.cidr_private[count.index]
    availability_zone = var.azs[count.index]
    map_public_ip_on_launch = false
    tags = var.private_subnet_tags
}

resource "aws_route_table" "private-route" {
    vpc_id = aws_vpc.vpc.id
    count = length(aws_subnet.private-subnet.*.id)
    route {
        nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
        cidr_block = "0.0.0.0/0"
    }

    tags ={
        Name = "Private Route Table ${count.index} - ${var.name}"
    }
}

resource "aws_route_table_association" "private-association" {
    count = length(aws_route_table.private-route.*.id) 
    subnet_id = aws_subnet.private-subnet[count.index].id
    route_table_id = aws_route_table.private-route[count.index].id
}
/*
  NAT Instance
*/

resource "aws_eip" "nat" {
    count = length(aws_subnet.private-subnet.*.id)
    vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
    count = length(aws_subnet.public-subnet.*.id)
    allocation_id = aws_eip.nat[count.index].id
    subnet_id = aws_subnet.public-subnet[count.index].id
    tags = {
     "Name" = "NatGateway ${count.index}- ${var.name}"
    }
}

/*
    Internet Gateway
*/

resource "aws_internet_gateway" "default" {
    vpc_id = aws_vpc.vpc.id
}