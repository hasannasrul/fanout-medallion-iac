# Fanout Medallion IAC

Infrastructure as Code for a **medallion architecture** data pipeline on AWS, featuring S3, SNS, SQS, and Lambda integration using Terraform.

## Overview

This project implements a **fan-out messaging architecture** across three data layers (bronze, silver, gold) with the following components:

- **S3 Buckets**: Three layers for raw data (bronze), transformed data (silver), and analytics-ready data (gold)
- **SNS Topics**: One topic per layer to broadcast S3 object creation events
- **SQS Queues**: One queue per layer subscribed to corresponding SNS topics
- **Event-Driven Pipeline**: S3 events automatically trigger SNS, which fans out to SQS for downstream processing

## Architecture
S3 Bucket (bronze) → SNS Topic (bronze) → SQS Queue (bronze) -> Lambda (bronze)
S3 Bucket (silver) → SNS Topic (silver) → SQS Queue (silver)
S3 Bucket (gold) → SNS Topic (gold) → SQS Queue (gold)