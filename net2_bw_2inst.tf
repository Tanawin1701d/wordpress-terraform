#STEP create subnet
resource "aws_subnet" "sec2_sn" {
  vpc_id                  = aws_vpc.proj_vpc.id
  cidr_block              = var.sec2_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone


  tags = {
    Name = "sec2_sn"
  }
}
# security

resource "aws_security_group" "sec2_sg" {
  name        = "allow internal"
  description = "Allow com bet2 ec2 ws & db"
  vpc_id      = aws_vpc.proj_vpc.id
  #   ingress {
  #     description = "HTTPS"
  #     from_port   = 443
  #     to_port     = 443
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  #   ingress {
  #     description = "HTTP"
  #     from_port   = 80
  #     to_port     = 80
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # ingress {
  #   description = "SSH"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # egress {
  #   description = "SSH"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sec2_sg"
  }
}

#STEP create new interface
resource "aws_network_interface" "sec2_net_itf_ws" {
  subnet_id       = aws_subnet.sec2_sn.id
  private_ips     = [var.sec2_net_inf_addr]
  security_groups = [aws_security_group.sec2_sg.id]

}
resource "aws_network_interface" "sec2_net_itf_db" {
  subnet_id       = aws_subnet.sec2_sn.id
  private_ips     = [var.sec2_net_inf_addr2]
  security_groups = [aws_security_group.sec2_sg.id]
}