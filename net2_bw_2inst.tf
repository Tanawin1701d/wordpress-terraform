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

resource "aws_security_group" "sec2_sg_ws" {
  name        = "allow internal ws"
  description = "Allow com bet2 ec2 ws & db"
  vpc_id      = aws_vpc.proj_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sec2_sg_ws"
  }
}

resource "aws_security_group" "sec2_sg_db" {
  name        = "allow internal db"
  description = "Allow com bet2 ec2 ws & db"
  vpc_id      = aws_vpc.proj_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "db"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [ "${cidrhost("${var.sec2_net_inf_addr}/32", 0)}/32" ]
  }

  tags = {
    Name = "sec2_sg_db"
  }
}

#STEP create new interface
resource "aws_network_interface" "sec2_net_itf_ws" {
  subnet_id       = aws_subnet.sec2_sn.id
  private_ips     = [var.sec2_net_inf_addr]
  security_groups = [aws_security_group.sec2_sg_ws.id]

}
resource "aws_network_interface" "sec2_net_itf_db" {
  subnet_id       = aws_subnet.sec2_sn.id
  private_ips     = [var.sec2_net_inf_addr2]
  security_groups = [aws_security_group.sec2_sg_db.id]
}