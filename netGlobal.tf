#STEP create vpc

resource "aws_vpc" "proj_vpc" {
  cidr_block = var.sec0_cidr_block
  tags = {
    "Name" = "proj_vpc"
  }
}