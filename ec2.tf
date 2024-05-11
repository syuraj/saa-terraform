resource "aws_instance" "bastion_host" {
  ami                    = "ami-051f8a213df8bc089"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = "suraj-key"
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]

  tags = {
    Name = "BastionHost"
  }
}

resource "aws_instance" "public_instances" {
  count                  = 2
  ami                    = "ami-0030623d3c9896d1a"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = "suraj-key"
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_web_server_profile.name

  tags = {
    "Name" = "publicInstance${count.index + 1}",
    "app"  = "demo-app"
  }
}

resource "aws_security_group" "web_server_sg" {
  name   = "web_server_sg"
  vpc_id = aws_vpc.saa_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    cidr_blocks = []
    from_port   = 3000
    protocol    = "tcp"
    security_groups = [
      aws_security_group.alb_sg.id
    ]
    self    = false
    to_port = 3000
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_server_sg"
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
