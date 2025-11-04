terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# S3 Buckets for Frontend Apps
resource "aws_s3_bucket" "shell" {
  bucket = "micro-frontend-shell-2025-${var.environment}"

  tags = {
    Name        = "Micro Frontend Shell"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "dashboard" {
  bucket = "micro-frontend-dashboard-2025-${var.environment}"

  tags = {
    Name        = "Micro Frontend Dashboard"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "orders" {
  bucket = "micro-frontend-orders-2025-${var.environment}"

  tags = {
    Name        = "Micro Frontend Orders"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "products" {
  bucket = "micro-frontend-products-2025-${var.environment}"

  tags = {
    Name        = "Micro Frontend Products"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "analytics" {
  bucket = "micro-frontend-analytics-2025-${var.environment}"

  tags = {
    Name        = "Micro Frontend Analytics"
    Environment = var.environment
  }
}

# S3 Bucket Public Access Configuration
resource "aws_s3_bucket_public_access_block" "shell" {
  bucket = aws_s3_bucket.shell.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_public_access_block" "dashboard" {
  bucket = aws_s3_bucket.dashboard.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_public_access_block" "orders" {
  bucket = aws_s3_bucket.orders.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_public_access_block" "products" {
  bucket = aws_s3_bucket.products.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_public_access_block" "analytics" {
  bucket = aws_s3_bucket.analytics.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# CloudFront Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for Micro Frontend S3 buckets"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name = aws_s3_bucket.shell.bucket_regional_domain_name
    origin_id   = "shell"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_s3_bucket.dashboard.bucket_regional_domain_name
    origin_id   = "dashboard"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_s3_bucket.orders.bucket_regional_domain_name
    origin_id   = "orders"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_s3_bucket.products.bucket_regional_domain_name
    origin_id   = "products"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_s3_bucket.analytics.bucket_regional_domain_name
    origin_id   = "analytics"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "shell"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    path_pattern     = "/dashboard/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "dashboard"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    path_pattern     = "/orders/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "orders"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    path_pattern     = "/products/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "products"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    path_pattern     = "/analytics/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "analytics"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name        = "Micro Frontend Distribution"
    Environment = var.environment
  }
}

# ECR Repositories
resource "aws_ecr_repository" "api_users" {
  name                 = "micro-frontend/api-users"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "API Users Repository"
    Environment = var.environment
  }
}

resource "aws_ecr_repository" "api_orders" {
  name                 = "micro-frontend/api-orders"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "API Orders Repository"
    Environment = var.environment
  }
}

resource "aws_ecr_repository" "api_products" {
  name                 = "micro-frontend/api-products"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "API Products Repository"
    Environment = var.environment
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "micro-frontend-cluster-${var.environment}"

  tags = {
    Name        = "Micro Frontend Cluster"
    Environment = var.environment
  }
}

# ECS Task Definitions
resource "aws_ecs_task_definition" "api_users" {
  family                   = "api-users-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "api-users"
      image = "${aws_ecr_repository.api_users.repository_url}:latest"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "NODE_ENV"
          value = "production"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/api-users-${var.environment}"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      healthCheck = {
        command = ["CMD-SHELL", "curl -f http://localhost:3000/ || exit 1"]
        interval = 30
        timeout = 5
        retries = 3
      }
    }
  ])

  tags = {
    Name        = "API Users Task Definition"
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "api_orders" {
  family                   = "api-orders-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "api-orders"
      image = "${aws_ecr_repository.api_orders.repository_url}:latest"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "NODE_ENV"
          value = "production"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/api-orders-${var.environment}"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      healthCheck = {
        command = ["CMD-SHELL", "curl -f http://localhost:3000/ || exit 1"]
        interval = 30
        timeout = 5
        retries = 3
      }
    }
  ])

  tags = {
    Name        = "API Orders Task Definition"
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "api_products" {
  family                   = "api-products-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "api-products"
      image = "${aws_ecr_repository.api_products.repository_url}:latest"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "NODE_ENV"
          value = "production"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/api-products-${var.environment}"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      healthCheck = {
        command = ["CMD-SHELL", "curl -f http://localhost:3000/ || exit 1"]
        interval = 30
        timeout = 5
        retries = 3
      }
    }
  ])

  tags = {
    Name        = "API Products Task Definition"
    Environment = var.environment
  }
}

# IAM Roles
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "ECS Execution Role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "ECS Task Role"
    Environment = var.environment
  }
}

# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "api_users" {
  name              = "/ecs/api-users-${var.environment}"
  retention_in_days = 30

  tags = {
    Name        = "API Users Log Group"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "api_orders" {
  name              = "/ecs/api-orders-${var.environment}"
  retention_in_days = 30

  tags = {
    Name        = "API Orders Log Group"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "api_products" {
  name              = "/ecs/api-products-${var.environment}"
  retention_in_days = 30

  tags = {
    Name        = "API Products Log Group"
    Environment = var.environment
  }
}

# Outputs
output "cloudfront_distribution_id" {
  description = "CloudFront Distribution ID for GitHub Actions"
  value       = aws_cloudfront_distribution.main.id
}

output "cloudfront_domain_name" {
  description = "CloudFront Distribution Domain Name"
  value       = aws_cloudfront_distribution.main.domain_name
}

output "s3_bucket_names" {
  description = "S3 Bucket names for frontend apps"
  value = {
    shell     = aws_s3_bucket.shell.bucket
    dashboard = aws_s3_bucket.dashboard.bucket
    orders    = aws_s3_bucket.orders.bucket
    products  = aws_s3_bucket.products.bucket
    analytics = aws_s3_bucket.analytics.bucket
  }
}

output "ecr_repository_urls" {
  description = "ECR Repository URLs for Docker images"
  value = {
    api_users   = aws_ecr_repository.api_users.repository_url
    api_orders  = aws_ecr_repository.api_orders.repository_url
    api_products = aws_ecr_repository.api_products.repository_url
  }
}

output "ecs_cluster_name" {
  description = "ECS Cluster Name"
  value       = aws_ecs_cluster.main.name
}
