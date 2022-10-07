#STEP gateway

resource "aws_internet_gateway" "sec0_gw" {
  vpc_id = aws_vpc.proj_vpc.id
  tags = {
    "Name" = "sec0_gw" // stand for internet gw
  }
}

#STEP route table and subnet

resource "aws_route_table" "sec0_rtb" {
  vpc_id = aws_vpc.proj_vpc.id
  //TODO maybe specify the route
  tags = {
    "Name" = "sec0_rtb"
  }
}

resource "aws_route" "sec0_route" {
  //TODO maybe specify the route
  route_table_id         = aws_route_table.sec0_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.sec0_gw.id
}

resource "aws_subnet" "sec0_sn" {
  vpc_id                  = aws_vpc.proj_vpc.id
  cidr_block              = var.sec0_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = "sec0_sn"
  }

}

#STEP bind subnet

resource "aws_route_table_association" "sec0_rtb_sn_ass" {
  subnet_id      = aws_subnet.sec0_sn.id
  route_table_id = aws_route_table.sec0_rtb.id
}


#STEP security
#TODO make own
resource "aws_security_group" "sec0_sg" {
  name        = "sec0_sg"
  description = "Allow web and ssh(for debugging)"
  vpc_id      = aws_vpc.proj_vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
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
    Name = "sec0_sg"
  }
}

#STEP interface & elastic ip

resource "aws_network_interface" "sec0_net_itf" {
  subnet_id       = aws_subnet.sec0_sn.id
  private_ips     = [var.sec0_net_inf_addr]
  security_groups = [aws_security_group.sec0_sg.id]


}

resource "aws_eip" "sec0_eip_ws" {
  vpc                       = true
  network_interface         = aws_network_interface.sec0_net_itf.id
  associate_with_private_ip = var.sec0_net_inf_addr
  depends_on                = [aws_internet_gateway.sec0_gw]

}

