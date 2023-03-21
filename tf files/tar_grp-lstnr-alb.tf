resource "aws_lb_target_group" "TG-ALB" {
  name        = "Phonebook-app-ALB"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.phonebook-vpc.id
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 20
    timeout             = 5
    path                = "/"
    protocol            = "HTTP"
  }
}


resource "aws_lb_listener" "ALB-listener" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG-ALB.arn
  }
}

resource "aws_lb" "ALB" {
  name               = "Phonebook-ALB"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALB-sec-grp.id]
  subnet_mapping {
    subnet_id = aws_subnet.subnet1a.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.subnet1b.id
  }

  tags = {
    Name = "ALB-Phonebook App"
  }
}