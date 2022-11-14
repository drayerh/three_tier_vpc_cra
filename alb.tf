# Creating External LoadBalancer
resource "aws_lb" "external" {
  name                       = "demovpc-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.demosg.id]
  subnets                    = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "target_elb" {
  name     = "ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.demovpc.id
}

resource "aws_lb_target_group_attachment" "attachment1" {
  target_group_arn = aws_lb_target_group.target_elb.arn
  target_id        = aws_instance.demoinstance1.id
  port             = 80

  depends_on = [
    aws_instance.demoinstance1
  ]
}

resource "aws_lb_target_group_attachment" "attachment2" {
  target_group_arn = aws_lb_target_group.target_elb.arn
  target_id        = aws_instance.demoinstance2.id
  port             = 80

  depends_on = [
    aws_instance.demoinstance2
  ]
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.external.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_elb.arn
  }
}