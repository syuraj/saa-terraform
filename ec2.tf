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
  iam_instance_profile   = aws_iam_instance_profile.ec2_web_server_profile.name

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

resource "aws_iam_role" "ec2_web_server_role" {
  name = "ec2-webserver-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "ec2.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "webserver_policy" {
  name = "webserver-Policy"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "arn:aws:logs:*:*:*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "webserver_s3_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.ec2_web_server_role.name
}

resource "aws_iam_instance_profile" "ec2_web_server_profile" {
  name = "ec2-webserver-profile"
  role = aws_iam_role.ec2_web_server_role.name
}

resource "aws_iam_role_policy_attachment" "webserver_policy_attachment" {
  role       = aws_iam_role.ec2_web_server_role.name
  policy_arn = aws_iam_policy.webserver_policy.arn
}
