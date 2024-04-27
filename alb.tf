resource "aws_lb" "public_lb" {
  name               = "saa-public-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  enable_deletion_protection = false

  tags = {
    Name = "saa-public-lb"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.saa_vpc.id

  # Allow inbound HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound HTTPS traffic (optional)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_lb_target_group" "saa-public-lb-target-group" {
  name     = "saa-public-lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.saa_vpc.id
}


resource "aws_lb_listener" "saa-public-lb-listener" {
  load_balancer_arn = aws_lb.public_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.saa-public-lb-target-group.arn
  }
}

resource "aws_lb_target_group_attachment" "saa-public-lb-target-group-attach1" {
  target_group_arn = aws_lb_target_group.saa-public-lb-target-group.arn
  target_id        = aws_instance.private_instances[0].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "saa-public-lb-target-group-attach2" {
  target_group_arn = aws_lb_target_group.saa-public-lb-target-group.arn
  target_id        = aws_instance.private_instances[1].id
  port             = 80
}
