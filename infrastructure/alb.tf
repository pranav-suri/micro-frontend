# Application Load Balancer for API Services

# ALB for APIs
resource "aws_lb" "api" {
  name               = "micro-frontend-api-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.aws_subnets.default.ids

  enable_deletion_protection = false

  tags = {
    Name        = "Micro Frontend API ALB"
    Environment = var.environment
  }
}

# Security Group for ALB
resource "aws_security_group" "alb" {
  name        = "api-alb-sg-${var.environment}"
  description = "Security group for API Application Load Balancer"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name        = "API ALB Security Group"
    Environment = var.environment
  }
}

# Target Groups
resource "aws_lb_target_group" "api_users" {
  name        = "api-users-tg-${var.environment}"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  deregistration_delay = 30

  tags = {
    Name        = "API Users Target Group"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "api_orders" {
  name        = "api-orders-tg-${var.environment}"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  deregistration_delay = 30

  tags = {
    Name        = "API Orders Target Group"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "api_products" {
  name        = "api-products-tg-${var.environment}"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  deregistration_delay = 30

  tags = {
    Name        = "API Products Target Group"
    Environment = var.environment
  }
}

# ALB Listener
resource "aws_lb_listener" "api" {
  load_balancer_arn = aws_lb.api.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }

  tags = {
    Name        = "API ALB Listener"
    Environment = var.environment
  }
}

# Listener Rules
resource "aws_lb_listener_rule" "api_users" {
  listener_arn = aws_lb_listener.api.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_users.arn
  }

  condition {
    path_pattern {
      values = ["/api/users/*", "/api/users"]
    }
  }

  tags = {
    Name        = "API Users Listener Rule"
    Environment = var.environment
  }
}

resource "aws_lb_listener_rule" "api_orders" {
  listener_arn = aws_lb_listener.api.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_orders.arn
  }

  condition {
    path_pattern {
      values = ["/api/orders/*", "/api/orders"]
    }
  }

  tags = {
    Name        = "API Orders Listener Rule"
    Environment = var.environment
  }
}

resource "aws_lb_listener_rule" "api_products" {
  listener_arn = aws_lb_listener.api.arn
  priority     = 102

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_products.arn
  }

  condition {
    path_pattern {
      values = ["/api/products/*", "/api/products"]
    }
  }

  tags = {
    Name        = "API Products Listener Rule"
    Environment = var.environment
  }
}

# Data source for default VPC
data "aws_vpc" "default" {
  default = true
}

# Outputs
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.api.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.api.zone_id
}
