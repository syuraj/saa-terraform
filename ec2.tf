resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.my_vpc.id

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

resource "aws_instance" "bastion_host" {
  ami             = "ami-123456" # Replace with a valid AMI ID
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet.id
  key_name        = "suraj-key"
  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "BastionHost"
  }
}

resource "aws_instance" "private_instance_1" {
  ami           = "ami-123456" # Replace with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_1.id
  key_name      = "suraj-key"

  tags = {
    Name = "PrivateInstance1"
  }
}

resource "aws_instance" "private_instance_2" {
  ami           = "ami-123456" # Replace with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet_2.id
  key_name      = "suraj-key"

  tags = {
    Name = "PrivateInstance2"
  }
}
