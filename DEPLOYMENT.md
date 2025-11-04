# Micro-Frontend Monorepo Deployment Guide

This guide covers the complete deployment setup for the micro-frontend monorepo using AWS infrastructure.

## Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   CloudFront    │    │       S3        │    │      ECS        │
│ Distribution    │◄──►│   Buckets       │    │   Fargate       │
│                 │    │                 │    │                 │
│ - shell/        │    │ - shell         │    │ - api-users     │
│ - dashboard/    │    │ - dashboard     │    │ - api-orders    │
│ - orders/       │    │ - orders        │    │ - api-products  │
│ - products/     │    │ - products      │    │                 │
│ - analytics/    │    │ - analytics     │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
       ▲                       ▲                       ▲
       │                       │                       │
       └───────────────────────┼───────────────────────┘
                               ▼
                       ┌─────────────────┐
                       │     ECR         │
                       │ Repositories    │
                       │                 │
                       │ - api-users     │
                       │ - api-orders    │
                       │ - api-products  │
                       └─────────────────┘
```

## Prerequisites

### AWS Account Setup
1. Create an AWS account or use existing one
2. Set up AWS CLI locally:
   ```bash
   aws configure
   ```
3. Create IAM user with necessary permissions (see infrastructure/README.md)

### Local Development
1. Install Docker and Docker Compose
2. Install Terraform v1.0+
3. Install Node.js 20+
4. Clone the repository

## Local Development Setup

### Using Docker Compose
```bash
# Start all API services locally
docker-compose up

# Access services at:
# - API Users: http://localhost:3001
# - API Orders: http://localhost:3002
# - API Products: http://localhost:3003
```

### Frontend Development
```bash
# Install dependencies
npm install

# Start shell app
npx nx serve shell

# Start other apps in separate terminals
npx nx serve dashboard
npx nx serve orders
npx nx serve products
npx nx serve analytics
```

## Infrastructure Deployment

### 1. Deploy AWS Infrastructure

```bash
cd infrastructure

# Initialize Terraform
terraform init

# Plan deployment (choose environment)
terraform plan -var="environment=dev"

# Apply infrastructure
terraform apply -var="environment=dev"
```

### 2. Configure GitHub Secrets

Add the following secrets to your GitHub repository:
- `AWS_ACCESS_KEY_ID`: Your AWS access key
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret key
- `CLOUDFRONT_DISTRIBUTION_ID`: From Terraform output

### 3. Initial Deployment

Push to main branch to trigger automatic deployment:
```bash
git add .
git commit -m "Initial deployment setup"
git push origin main
```

## CI/CD Workflows

### Frontend Deployment
- **Trigger**: Push to main branch with frontend changes
- **Process**:
  1. Build all frontend apps
  2. Upload to respective S3 buckets
  3. Invalidate CloudFront cache

### Backend Deployment
- **Trigger**: Push to main branch with API changes
- **Process**:
  1. Build Docker images
  2. Push to ECR
  3. Update ECS services

## Environment Management

### Environment Files
- `environments/.env.production` - Production configuration
- `environments/.env.staging` - Staging configuration

### Environment Variables
Update API endpoints in environment files after infrastructure deployment.

## Monitoring and Troubleshooting

### Health Checks
- ECS services have built-in health checks
- CloudFront monitors origin health
- Use CloudWatch for logs and metrics

### Common Issues

#### Frontend Not Loading
1. Check CloudFront distribution status
2. Verify S3 bucket permissions
3. Check CloudFront invalidation status

#### API Not Responding
1. Check ECS service status: `aws ecs describe-services`
2. View logs: `aws logs tail /ecs/api-users-prod`
3. Verify security groups and network configuration

#### Build Failures
1. Check GitHub Actions logs
2. Verify AWS credentials
3. Ensure Docker images build correctly locally

## Scaling

### Frontend Scaling
- CloudFront automatically scales globally
- S3 has unlimited storage and bandwidth

### Backend Scaling
```bash
# Update desired count for ECS service
aws ecs update-service \
  --cluster micro-frontend-cluster-prod \
  --service api-users-service \
  --desired-count 3
```

## Backup and Recovery

### S3 Versioning
Enable versioning on S3 buckets for backup:
```bash
aws s3api put-bucket-versioning \
  --bucket micro-frontend-shell-prod \
  --versioning-configuration Status=Enabled
```

### Database Backups
If you add databases later, configure automated backups through AWS Backup.

## Security

### SSL/TLS
1. Request ACM certificate for your domain
2. Update CloudFront distribution to use custom certificate
3. Configure SSL termination at CloudFront

### Network Security
- Use VPC for ECS services
- Configure security groups appropriately
- Enable CloudTrail for audit logging

## Cost Optimization

### S3 Storage Classes
Consider moving older objects to cheaper storage classes:
```bash
aws s3api put-bucket-lifecycle-configuration \
  --bucket micro-frontend-shell-prod \
  --lifecycle-configuration file://lifecycle.json
```

### ECS Reserved Instances
For production workloads, consider reserved instances for cost savings.

## Maintenance

### Regular Tasks
1. Monitor CloudWatch metrics and logs
2. Update dependencies monthly
3. Review and rotate access keys quarterly
4. Test disaster recovery annually

### Updates
1. Test changes in staging environment first
2. Use feature flags for gradual rollouts
3. Monitor performance after deployments
4. Roll back immediately if issues detected

## Support

For issues:
1. Check GitHub Actions logs
2. Review CloudWatch logs
3. Check AWS service status
4. Contact DevOps team

## Appendix

### Useful Commands

```bash
# Check ECS service status
aws ecs describe-services --cluster micro-frontend-cluster-prod --services api-users-service

# View recent logs
aws logs tail /ecs/api-users-prod --follow

# List S3 buckets
aws s3 ls

# Check CloudFront distribution
aws cloudfront list-distributions
```

### Resource Naming Convention
- S3 buckets: `micro-frontend-{app}-{environment}`
- ECR repos: `micro-frontend/{app}`
- ECS services: `{app}-service`
- CloudWatch logs: `/ecs/{app}-{environment}`
