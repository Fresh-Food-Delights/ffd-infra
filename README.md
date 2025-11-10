# ffd-infra

Infrastructure-as-Code repository for the Fresh Food Delights mock organization. This repository supports the Purdue University Global IT473 Bachelor’s Capstone in Cloud Computing and Solutions. The project establishes foundational AWS infrastructure using Terraform with secure, review-driven version control workflows.

## Core Infrastructure Components

- Remote Terraform state stored securely in S3
- Terraform state locking enforced through DynamoDB
- Versioning and SSE-S3 encryption enabled on all infrastructure buckets
- Public access blocked through ACL and bucket policy configuration
- The `main` branch is protected and requires pull requests with review

## AWS Resources Managed in Terraform

Resource - Purpose
- ffd-tfstate-* (S3 Bucket) - Stores Terraform state
- ffd-artifacts-* (S3 Bucket) - Reserved for build and deployment artifacts
- ffd-logs-* (S3 Bucket) - Reserved for centralized logging storage
- ffd-tf-lock (DynamoDB Table) - Provides Terraform state locking

## Repository Structure

```
ffd-infra/
├── README.md
├── backend.hcl                 (S3 + DynamoDB backend configuration)
├── providers.tf                (AWS provider configuration + version pin)
├── .gitignore                  (Prevents `.terraform` and local state files from being committed)
│
├── policies/                   (AWS bucket access & security configuration)
│   ├── artifacts-policy.json   (S3 access policy for artifacts bucket)
│   ├── logs-policy.json        (S3 access policy for logs bucket)
│   ├── tfstate-policy.json     (S3 access policy for Terraform state bucket)
│   │
│   ├── public-block.json       (Bucket-level public access block configuration)
│   ├── ownership.json          (BucketOwnerPreferred object ownership rule)
│   └── sse.json                (Default SSE-S3 encryption configuration rule)
│
└── modules/                    (Reusable Terraform modules — will be populated in later units)
```

## Terraform Workflow

### First-time Setup (new workstation / contributor)

terraform init -backend-config="backend.hcl"

> Do not run `terraform init -reconfigure` unless intentionally modifying backend configuration.

### Standard Workflow

terraform fmt  
terraform validate  
terraform plan  
terraform apply

## Branch Workflow

- All work is performed in feature branches
- Direct pushes to `main` are restricted
- Pull requests require review before merging
- Status checks must pass prior to merge
- Linear commit history is maintained

## Project Roadmap (High-Level)

- Expand foundational VPC networking (subnets, routing, NAT)
- Deploy compute and managed database services
- Apply IAM hardening and edge protection controls
- Implement centralized logging and monitoring dashboards
- Validate deployment, finalize documentation, and complete handoff
