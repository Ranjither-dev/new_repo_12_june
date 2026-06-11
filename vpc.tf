#vpc creaton
resource "aws_vpc" "my_vpc" {

    cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "my_vpc"
  }
}

#public subet creation

 resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public_subnet"
  }
}

#private subnet creation

 resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private_subnet"
  }
}

#internet gateway creation

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw"
  }
}

#route table creation for public and private sub

resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "public_RT"
  }
} 
resource "aws_route_table" "private_RT" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "private_RT"
  }
} 

#attaching igw to publioc route table
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_RT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}
#route table association for public and private sub

resource "aws_route_table_association" "public_RT_ASS" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_RT.id
  }

  resource "aws_route_table_association" "private_RT_ASS" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_RT.id
  }

  #elastic ip creation

  resource "aws_eip" "eip" {
}

#nat_gateway creation

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "my_NAT_gw"
  }

}

#security group creation

resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "public_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_sg_ingress_ipv4" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         =  "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 65535
}

resource "aws_vpc_security_group_egress_rule" "public_sg_egress_ipv4" {
  security_group_id = aws_security_group.public_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "private_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_sg_ingress_ipv4" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = "10.0.1.0/24"
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 65535
}

resource "aws_vpc_security_group_egress_rule" "private_sg_egress_ipv4" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


