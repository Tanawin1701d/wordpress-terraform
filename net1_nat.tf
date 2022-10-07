########## internet gw zone
#STEP create subnet and eip

# resource "aws_internet_gateway" "sec1_gw" {
#   vpc_id = aws_vpc.proj_vpc.id
#   tags = {
#     "Name" = "sec1_gw" // stand for internet gw
#   }
# }

resource "aws_subnet" "sec1_sn_pub" {
  vpc_id                  = aws_vpc.proj_vpc.id
  cidr_block              = var.sec1_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = "sec1_sn_pub"
  }

}

resource "aws_route_table" "sec1_nat_rtb_pub" {
  vpc_id = aws_vpc.proj_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sec0_gw.id
  }

  tags = {
    "Name" = "sec1_nat_rtb_pub"
  }
}

resource "aws_route_table_association" "sec1_rtb_sn_nat_ass" {
  subnet_id      = aws_subnet.sec1_sn_pub.id
  route_table_id = aws_route_table.sec1_nat_rtb_pub.id
}

########## nat zone

#STEP create nat gateway

resource "aws_eip" "sec1_eip_db" {
  vpc = true
  #network_interface         = aws_network_interface.proj_ws_itf.id
  #associate_with_private_ip = var.sec1_net_inf_addr
  depends_on = [aws_internet_gateway.sec0_gw]
}

resource "aws_nat_gateway" "sec1_ngw" {
  allocation_id = aws_eip.sec1_eip_db.id
  subnet_id     = aws_subnet.sec1_sn_pub.id

  tags = {
    Name = "sec1_ngw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.sec0_gw]
}

#STEP private section

#STEP create route table and route

resource "aws_route_table" "sec1_rtb" {
  vpc_id = aws_vpc.proj_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.sec1_ngw.id
  }

  tags = {
    "Name" = "sec1_rtb"
  }
}


resource "aws_subnet" "sec1_priv_sn" {
  vpc_id                  = aws_vpc.proj_vpc.id
  cidr_block              = var.sec1_priv_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone

  tags = {
    Name = "sec1_priv_sn"
  }

}


#STEP bind subnet

resource "aws_route_table_association" "sec1_rtb_sn_ass" {
  subnet_id      = aws_subnet.sec1_priv_sn.id
  route_table_id = aws_route_table.sec1_rtb.id
}

#STEP security

resource "aws_security_group" "sec1_sg" {
  name        = "allow_db"
  description = "Allow db ec2 download mariadb"
  vpc_id      = aws_vpc.proj_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_db"
  }
}


#STEP create interface
resource "aws_network_interface" "sec1_net_itf" {
  subnet_id       = aws_subnet.sec1_priv_sn.id
  private_ips     = [var.sec1_net_inf_addr]
  security_groups = [aws_security_group.sec1_sg.id]
}
