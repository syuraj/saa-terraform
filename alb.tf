resource "aws_lb" "public_lb" {
  name               = "my-public-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_ssh.id]
  subnets            = [aws_subnet.public_subnet.id]

#   enable_deletion_pro
}