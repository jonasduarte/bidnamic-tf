# Allocate public IP address for the load balancer
resource "aws_eip" "lb-eip" {
  tags = local.base_tags
}

# Configure the application load balancer security group
resource "aws_security_group" "bd-lb-sg" {
  name        = "bd-lb-sg"
  description = "LB Security Group for BD Application"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow HTTPS from the anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTP from the anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = join("-", [upper(var.environment), var.code_version])
    Environment = upper(var.environment)
    Version     = var.code_version
  }
}

# Create an application load balancer
resource "aws_lb" "bd-lb" {
  name               = "bd-lb"
  load_balancer_type = "application"
  internal           = false
  subnets            = [aws_subnet.public_az1.id, aws_subnet.public_az2.id]
  security_groups    = [aws_security_group.bd-lb-sg.id]
  ip_address_type    = "ipv4"
  tags = {
    Name        = join("-", [upper(var.environment), var.code_version])
    Environment = upper(var.environment)
    Version     = var.code_version
  }
}

# Configure the target group
resource "aws_lb_target_group" "bd-lb-tg" {
  name        = "bd-lb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"
  health_check {
    enabled             = true
    interval            = 10
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    matcher             = "200-299"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = local.base_tags
}

# Configure the target group destination instance for app-server-1
resource "aws_lb_target_group_attachment" "bd-lb-tg-att1" {
  target_group_arn = aws_lb_target_group.bd-lb-tg.arn
  target_id        = aws_instance.app-server-1.id
  port             = 80
}

# Configure the target group destination instance for app-server-2
resource "aws_lb_target_group_attachment" "bd-lb-tg-att2" {
  target_group_arn = aws_lb_target_group.bd-lb-tg.arn
  target_id        = aws_instance.app-server-2.id
  port             = 80
}

# Configure the Listener
resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.bd-lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.bd-lb-tg.arn
    type             = "forward"
  }
}
