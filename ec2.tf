resource "aws_instance" "bastion_host" {
  ami                    = "ami-051f8a213df8bc089"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = "suraj-key"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "BastionHost"
  }
}

resource "aws_instance" "private_instances" {
  count                  = 2
  ami                    = "ami-051f8a213df8bc089"
  instance_type          = "t2.micro"
  subnet_id              = count.index == 0 ? aws_subnet.private_subnet_1.id : aws_subnet.private_subnet_2.id
  key_name               = "suraj-key"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    "Name" = "PrivateInstance${count.index + 1}",
    "app"  = "demo-app"
  }
}

resource "aws_security_group" "allow_ssh" {
  name   = "allow_ssh"
  vpc_id = aws_vpc.saa_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Consider restricting this to known IPs for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}


