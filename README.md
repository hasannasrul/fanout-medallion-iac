# Fanout Medallion Architecture - Infrastructure as Code

Event-driven data pipeline using AWS S3, SNS, SQS, and RDS with Terraform. Free tier optimized.

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│              MEDALLION ARCHITECTURE (EVENT-DRIVEN)          │
└─────────────────────────────────────────────────────────────┘

BRONZE LAYER (Raw Data)
├─ User uploads file to S3
├─ S3:ObjectCreated event triggers
├─ SNS topic publishes event
├─ SQS queue buffers message

         ↓

SILVER LAYER (Cleaned Data)
├─ Lambda writes cleaned file to S3
├─ S3:ObjectCreated event triggers
├─ SNS topic publishes event
├─ SQS queue buffers message

         ↓

GOLD LAYER (Analytics Data)
├─ Lambda writes curated file to S3
├─ S3:ObjectCreated event triggers
├─ SNS topic publishes event
├─ SQS queue buffers message
```

## 📋 AWS Services Deployed

| Service        | Free Tier                 | Purpose                        |
| -------------- | ------------------------- | ------------------------------ |
| **S3**         | ✅ 5GB storage            | 3 buckets (Bronze/Silver/Gold) |
| **SNS**        | ✅ Unlimited              | Event fanout topics (3 topics) |
| **SQS**        | ✅ 1M msgs/mo             | Message buffering (3 queues)   |
| **RDS**        | ✅ 750 hrs/mo db.t3.micro | PostgreSQL 15 / MySQL 8        |
| **IAM**        | ✅ Always free            | Role management                |
| **CloudWatch** | ✅ 5GB/mo logs            | Monitoring                     |

## 🚀 Quick Start

### Prerequisites

- AWS Account
- Terraform >= 1.0
- AWS CLI configured

### 1. Initialize Terraform

```bash
cd terraform/environments/dev

# Initialize backend and modules
terraform init

# Validate configuration
terraform validate

# Plan deployment
terraform plan -out=tfplan
```

### 2. Deploy Infrastructure

```bash
# Apply the plan
terraform apply tfplan

# Save outputs (you'll need these for Lambda)
terraform output -json > ../../../lambda-config.json
```

### 3. Upload Infrastructure Config to S3 (Auto-generated Config Bucket)

After deployment, the **config bucket** is automatically created. Upload your infrastructure outputs:

```bash
# Export Terraform outputs as JSON
cd terraform/environments/dev
terraform output -json > infrastructure-config.json


aws s3 cp infrastructure-config.json s3://${CONFIG_BUCKET}/infrastructure-config.json

# Verify upload
aws s3 ls s3://${CONFIG_BUCKET}/
```

Your Lambda functions will read this config file from S3.



## 📊 Outputs Generated

After `terraform apply`, you'll get these outputs:

### S3 Buckets

```
bronze_bucket_name     → Raw data input bucket
silver_bucket_name     → Cleaned data bucket
gold_bucket_name       → Analytics-ready data bucket
```

### SQS Queues (Event triggers)

```
bronze_sqs_queue_url   → Triggers Bronze Lambda
silver_sqs_queue_url   → Triggers Silver Lambda
gold_sqs_queue_url     → Triggers Gold Lambda
```

### SNS Topics (Event publishers)

```
bronze_sns_topic_arn   → Publishes Bronze S3 events
silver_sns_topic_arn   → Publishes Silver S3 events
gold_sns_topic_arn     → Publishes Gold S3 events
```

### RDS Database

```
rds_endpoint           → host:port for database
rds_address            → Database hostname
rds_port               → Database port (5432 for PostgreSQL)
rds_database_name      → Default database name
```


### Check Queue Messages

```bash
# See if messages are in Bronze queue
aws sqs receive-message \
  --queue-url $(terraform output -raw bronze_sqs_queue_url) \
  --attribute-names All

# Get queue depth
aws sqs get-queue-attributes \
  --queue-url $(terraform output -raw bronze_sqs_queue_url) \
  --attribute-names ApproximateNumberOfMessages
```


## 🗂️ Project Structure

```
terraform/
├── main.tf                 # Root orchestration
├── variables.tf            # Input variables
├── outputs.tf              # Output values
├── provider.tf             # AWS provider config
├── modules/
│   ├── s3/                 # 3 S3 buckets
│   ├── sqs/                # 3 SQS queues
│   ├── sns/                # 3 SNS topics
│   ├── rds/                # PostgreSQL database
│   └── security/           # VPC security groups
└── environments/
    ├── dev/                # Development config
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   ├── terraform.tfvars
    │   └── provider.tf
    └── prod/               # Production config (similar)
```

## 💰 Cost Estimation (Monthly)

| Service   | Usage                | Cost      |
| --------- | -------------------- | --------- |
| S3        | 5GB storage          | FREE      |
| SNS       | <1M publishes        | FREE      |
| SQS       | <1M messages         | FREE      |
| RDS       | db.t3.micro, 750 hrs | FREE      |
| **Total** |                      | **$0.00** |

All within AWS free tier limits!

## 🔐 Security

- ✅ S3 buckets are **not public**
- ✅ **Encryption** enabled (AES-256)
- ✅ **Versioning** enabled on S3 buckets
- ✅ **IAM roles** with least-privilege permissions
- ✅ **VPC security groups** for Lambda↔RDS communication
- ✅ RDS publicly accessible (set to `false` in production)

## 📚 Commands Reference

### Deploy

```bash
terraform plan
terraform apply
```

### Get Outputs

```bash
terraform output -json
```

### Destroy

```bash
terraform destroy
```

### Validate

```bash
terraform validate
terraform fmt -recursive
```

## 🆘 Troubleshooting


### SNS → SQS Not Working

1. Verify subscription: `aws sns list-subscriptions-by-topic --topic-arn <ARN>`
2. Check queue policy: `aws sqs get-queue-attributes --queue-url <URL> --attribute-names Policy`
3. Verify SNS topic policy allows S3


## 📖 Next Steps

1. **Deploy infrastructure**: `terraform apply`
2. **Create Lambda functions** in separate repo (reference this infrastructure)
4. **Store Lambda config in S3** for easy updates
5. **Test pipeline** with sample data
6. **Monitor** with CloudWatch logs

## 🎯 Environment Variables for Lambda

Store these in S3 config file (not in code):

```json
{
  "bronze_bucket_name": "...",
  "silver_bucket_name": "...",
  "gold_bucket_name": "...",
  "bronze_sqs_queue_url": "...",
  "silver_sqs_queue_url": "...",
  "gold_sqs_queue_url": "...",
  "rds_address": "...",
  "rds_port": "...",
  "rds_database_name": "...",
  "rds_username": "admin",
  "rds_password": "..." // Store separately!
}
```

---

**Last Updated**: December 2025  
**Terraform Version**: >= 1.0  
**AWS Provider Version**: ~> 5.0
