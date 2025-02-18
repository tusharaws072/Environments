resource "aws_lb" "alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.server_sg_id]
  subnets            = "${var.alb_cidr}"
  enable_deletion_protection = false
  tags = {
    Name = "${var.project_name}-alb"
  }
}
 
resource "aws_lb_target_group" "tg" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  

  
  health_check {
    protocol = "HTTP"
    path = "/"
    port = "80"
  }
 

}

resource "aws_lb_target_group_attachment" "ec2_attachment" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.target_id
  port             = 80
}
 
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
