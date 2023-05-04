resource "aws_vpc" "network_vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = "${var.owner}_vpc"
  }
}

resource "aws_subnet" "network_subnet" {
  cidr_block = cidrsubnet(var.cidr_block, 8, 1)
  vpc_id = aws_vpc.network_vpc.id

  tags = {
    # TODO: Add tag to denote if this is private or public
    Name = "${var.owner}_subnet"
  }
}

resource "aws_route_table" "network_rtb" {
  vpc_id = aws_vpc.network_vpc.id

  # TODO: Add a condition to add this route only if the subnet is public.
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.network_igw.id
  }

  tags = {
    Name = "${var.owner}_rtb"
  } 
}

resource "aws_network_acl" "network_acl" {
  vpc_id = aws_vpc.network_vpc.id

  tags = {
    Name = "${var.owner}_acl"
  } 
}

resource "aws_route_table_association" "network_rtb_association" {
  subnet_id = aws_subnet.network_subnet.id
  route_table_id = aws_route_table.network_rtb.id 
}

# TODO: Add condition to only add an IGW if there is a public subnet
resource "aws_internet_gateway" "network_igw" {
  vpc_id = aws_vpc.network_vpc.id

  tags = {
    Name = "${var.owner}_igw"
  } 
}
