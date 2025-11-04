# AWS Infrastructure Setup

This directory contains Terraform configurations for deploying the micro-frontend monorepo to AWS.

## Architecture

- **Frontend**: S3 + CloudFront for static hosting
- **Backend APIs**: ECS Fargate for containerized deployment
- **Container Registry**: ECR for Docker images

## Prerequisites

1. AWS CLI configured with appropriate permissions
2. Terraform v1.0+
3. AWS account with necessary permissions

## Required AWS Permissions

Your AWS user/role needs the following permissions:
- S3: Full access to S3 buckets
- CloudFront: Full access to distributions
- ECR: Full access to repositories
- ECS: Full access to clusters, services, and task definitions
- IAM: Create roles and policies
- CloudWatch: Create log groups

## Deployment Steps

### 1. Initialize Terraform

```bash
cd infrastructure
terraform init
```

### 2. Plan Deployment

```bash
# For development
terraform plan -var="environment=dev"

# For staging
terraform plan -var="environment=staging"

# For production
terraform plan -var="environment=prod"
```

### 3. Apply Infrastructure

```bash
# For development
terraform apply -var="environment=dev"

# For staging
terraform apply -var="environment=staging"

# For production
terraform apply -var="environment=prod"
```

## Outputs

After deployment, Terraform will output:
- CloudFront distribution URL
- S3 bucket names
- ECR repository URLs
- ECS cluster name

## Cleanup

To destroy all resources:

```bash
terraform destroy -var="environment=<environment>"
```

## Environment Variables

Update the following in your CI/CD secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `CLOUDFRONT_DISTRIBUTION_ID` (from Terraform output)

## Next Steps

1. Update your domain DNS to point to CloudFront
2. Configure SSL certificates in CloudFront
3. Set up monitoring and alerting
4. Configure backup strategies
