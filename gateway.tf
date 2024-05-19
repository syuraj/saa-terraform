resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.saa_vpc.id
  tags = {
    Name = "saa_igw"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.private_subnet_1.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "saa_nat_gw"
  }
}
