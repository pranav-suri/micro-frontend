# Micro-Frontend Monorepo

A scalable micro-frontend architecture built with Nx, React, and AWS. This monorepo contains multiple frontend applications (shell, dashboard, orders, products, analytics) and backend APIs (users, orders, products) that work together as a unified application.

## 🏗️ Architecture

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
```

## 🚀 Quick Start

### Prerequisites

- **Node.js 20+**
- **AWS Account** with appropriate permissions
- **Git**

### 1. Clone and Setup

```bash
# Clone the repository
git clone <your-repo-url>
cd <your-project-directory>

# Install dependencies
npm install
```

### 2. AWS Configuration

#### Option A: AWS CLI Configuration (Recommended)

```bash
# Configure AWS CLI
aws configure

# When prompted:
# AWS Access Key ID: [Your Access Key]
# AWS Secret Access Key: [Your Secret Key]
# Default region name: us-east-1
# Default output format: json
```

#### Option B: Manual AWS Credentials Setup

Create AWS credentials file:

```bash
# Create .aws directory if it doesn't exist
mkdir -p ~/.aws

# Create credentials file
cat > ~/.aws/credentials << EOF
[default]
aws_access_key_id = YOUR_ACCESS_KEY_ID
aws_secret_access_key = YOUR_SECRET_ACCESS_KEY
EOF

# Create config file
cat > ~/.aws/config << EOF
[default]
region = us-east-1
output = json
EOF
```

### 3. Deploy Infrastructure

```bash
# Navigate to infrastructure directory
cd infrastructure

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan -var="environment=dev"

# Apply the infrastructure
terraform apply -var="environment=dev"
```

**Note**: Terraform will output important values like `cloudfront_distribution_id`. Save this for GitHub Actions setup.

### 4. Configure GitHub Actions (Optional)

If using GitHub for CI/CD:

1. Go to your GitHub repository → Settings → Secrets and variables → Actions
2. Add these secrets:
   - `AWS_ACCESS_KEY_ID`: Your AWS access key
   - `AWS_SECRET_ACCESS_KEY`: Your AWS secret key
   - `CLOUDFRONT_DISTRIBUTION_ID`: From Terraform output (e.g., `E2YDLTHDO3Q6GR`)

### 5. Deploy Application

```bash
# Push to main branch to trigger deployment
git add .
git commit -m "Initial deployment"
git push origin main
```

## 🛠️ Local Development

### Start All Services

```bash
# Start all backend APIs
docker-compose up

# APIs will be available at:
# - API Users: http://localhost:3001
# - API Orders: http://localhost:3002
# - API Products: http://localhost:3003
```

### Start Frontend Applications

```bash
# Terminal 1: Shell app (main container)
npx nx serve shell

# Terminal 2: Dashboard app
npx nx serve dashboard

# Terminal 3: Orders app
npx nx serve orders

# Terminal 4: Products app
npx nx serve products

# Terminal 5: Analytics app
npx nx serve analytics
```

### Access the Application

- **Shell App**: http://localhost:4200 (main application)
- **Individual Apps**: Available on different ports for development

## 📁 Project Structure

```
├── apps/
│   ├── shell/                 # Main shell application
│   ├── dashboard/             # Dashboard micro-frontend
│   ├── orders/                # Orders micro-frontend
│   ├── products/              # Products micro-frontend
│   ├── analytics/             # Analytics micro-frontend
│   ├── api-users/             # Users API
│   ├── api-orders/            # Orders API
│   └── api-products/          # Products API
├── shared-*/                  # Shared libraries
├── infrastructure/            # AWS Terraform configs
├── environments/              # Environment configs
├── .github/workflows/         # CI/CD pipelines
└── docker-compose.yml         # Local development setup
```

## 🚀 Deployment

### Automatic Deployment (GitHub Actions)

Push to the `main` branch to automatically:
- Build all frontend applications
- Deploy to S3 buckets
- Invalidate CloudFront cache
- Build and deploy APIs to ECS

### Manual Deployment

```bash
# Build all apps
npx nx run-many --target=build --configuration=production

# Deploy frontend (requires AWS CLI configured)
npm run deploy:frontend

# Deploy backend (requires AWS CLI configured)
npm run deploy:backend
```

## 🧹 Cleanup and Resource Management

### Delete All AWS Resources

```bash
# Navigate to infrastructure
cd infrastructure

# Destroy all resources
terraform destroy -var="environment=dev"

# Or destroy without confirmation
terraform destroy -var="environment=dev" --auto-approve
```

### Clean Local Development

```bash
# Stop Docker containers
docker-compose down

# Remove Docker volumes
docker-compose down -v

# Clean node_modules
rm -rf node_modules
npm install
```

## 🔧 Configuration

### Environment Variables

Update environment files in `environments/` directory:

- `.env.production` - Production configuration
- `.env.staging` - Staging configuration

### AWS Permissions Required

Your AWS user/role needs these permissions:
- S3: Full access to S3 buckets
- CloudFront: Full access to distributions
- ECR: Full access to repositories
- ECS: Full access to clusters, services, and task definitions
- IAM: Create roles and policies
- CloudWatch: Create log groups

## 📊 Monitoring

### Health Checks
- ECS services include built-in health checks
- CloudFront monitors origin health
- Use CloudWatch for logs and metrics

### Logs
```bash
# View ECS service logs
aws logs tail /ecs/api-users-dev --follow

# View CloudWatch metrics
aws cloudwatch get-metric-statistics --namespace AWS/ECS --metric-name CPUUtilization
```

## 🐛 Troubleshooting

### Common Issues

**Terraform Errors:**
```bash
# If you get credential errors
aws configure

# If resources already exist
terraform state list
terraform destroy -var="environment=dev"
```

**Build Errors:**
```bash
# Clear Nx cache
npx nx reset

# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install
```

**Deployment Issues:**
```bash
# Check GitHub Actions logs
# Verify AWS credentials are correct
# Ensure CloudFront distribution ID is set in secrets
```

## 📚 Additional Documentation

- [Deployment Guide](DEPLOYMENT.md) - Detailed deployment instructions
- [Infrastructure Setup](infrastructure/README.md) - AWS setup details
- [API Documentation](apps/api-*/README.md) - Individual API docs

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `npm test`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For issues:
1. Check the troubleshooting section
2. Review GitHub Actions logs
3. Check CloudWatch logs
4. Create an issue in the repository

---

**Happy coding! 🚀**
