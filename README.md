# ffd-infra

Infrastructure-as-Code repository for the Fresh Food Delights mock organization. This repository supports the Purdue University Global IT473 Bachelor’s Capstone in Cloud Computing and Solutions. It defines and automates AWS infrastructure using Terraform with strict version control and GitHub Actions for CI/CD.

## Core Infrastructure Design

- Secure, versioned Terraform state stored in S3
- State locking with DynamoDB to prevent concurrent writes
- Environments for `dev`, `test`, and `prod`, each with its own isolated infrastructure
- VPC isolation, multi-tier security design, and tier-specific modules
- GitHub Actions integration using AWS OIDC (no static credentials)
- Review-driven workflows with branch protection on `main`

## Key AWS Resources Deployed

| Resource Type       | Purpose                                                                                                                  |
|---------------------|--------------------------------------------------------------------------------------------------------------------------|
| S3 Buckets          | `ffd-tfstate-*`, `ffd-artifacts-*`, `ffd-logs-*` for state, builds, logs                                                 |
| DynamoDB            | `ffd-tf-lock` for Terraform backend state locking                                                                        |
| IAM                 | OIDC trust for GitHub Actions + scoped policies                                                                          |
| VPC + Subnets       | Isolated tiers for Web, App, and DB in each environment                                                                  |
| ALB, EC2, RDS       | Core infra components defined in code for web, app, and DB tiers; scaled to zero or disabled by default for cost control |
| VPC Endpoints       | Gateway endpoints for S3 and DynamoDB; interface endpoints for SSM/Secrets defined in modules                            |
| CloudFront + WAF    | Edge and L7 protection modules defined in code; disabled by default until explicitly enabled                             |
| Future:             | GuardDuty, CloudTrail, and additional security services (planned for deployment)                                         |

## 🗂 Repository Structure

```
FFD-INFRA/
├── .github/                     # GitHub Actions workflows
│   └── workflows/
│       └── terraform.yml
├── diagram/                     # Reference architecture visuals
│   └── diagram.jpg
├── envs/                        # Environment- and region-specific configuration
│   ├── dev/
│   │   └── us-east-1/
│   │       ├── backend.hcl
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       ├── tfplan
│   │       └── variables.tf
│   ├── test/
│   │   └── us-east-1/
│   │       ├── backend.hcl
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       ├── tfplan
│   │       └── variables.tf
│   └── prod/
│       ├── us-east-1/
│       │   ├── backend.hcl
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   ├── tfplan
│       │   └── variables.tf
│       └── us-west-1/
│           ├── backend.hcl
│           ├── main.tf
│           ├── outputs.tf
│           ├── tfplan
│           └── variables.tf
├── modules/                     # All Terraform modules used by environments
│   ├── alb-app/                 # Internal ALB targeting app tier (8080)
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── alb-web/                 # Public ALB targeting web tier (80)
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── asg-app/                 # App-tier Auto Scaling Group
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── asg-web/                 # Web-tier Auto Scaling Group
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── cloudfront/              # Optional CloudFront distribution
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── dynamodb/                # Optional DynamoDB tables
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── ec2/                     # General-purpose EC2 launcher
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── iam/                     # IAM roles and policies
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── nat/                     # NAT gateways per AZ
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── rds/                     # RDS database provisioning
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── routing/                 # Route tables per subnet tier
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── s3/                      # S3 buckets (web data and app data)
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── secrets/                 # AWS Secrets Manager integration
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── security/                # Security group abstractions
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── ssm/                     # SSM activation and commands
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── subnet/                  # Tiered subnet layout (per AZ)
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── vpc/                     # Core VPC and IGW
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── vpc_endpoints/           # Gateway endpoints (S3 and DynamoDB)
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── waf/                     # AWS WAF Web ACLs
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── policies/                    # S3 and IAM policy JSON files
│   ├── artifacts-policy.json
│   ├── logs-policy.json
│   ├── ownership.json
│   ├── public-block.json
│   ├── s3-policy-template.json
│   ├── sse.json
│   └── tfstate-policy.json
├── .gitignore
├── backend.hcl                  # Shared backend config for remote state
├── providers.tf                 # Terraform provider configuration
├── README.md
└── tfplan                       # Root-level plan artifact
```


---

## 🔧 Modules Overview

All modules below are fully implemented in Terraform. Cost-driving resources (ASGs, RDS, NAT, CloudFront/WAF, etc.) are either scaled to `0/0/0` or disabled by default and can be enabled via variables when needed.

| Modules         | Purpose                                                                                                   |
|-----------------|-----------------------------------------------------------------------------------------------------------|
| `alb-web`       | Public Application Load Balancer for web tier (HTTP 80) (disabled by default)                             |
| `alb-app`       | Internal Application Load Balancer for app tier (HTTP 8080) (disabled by default)                         |
| `asg-web`       | Auto Scaling Group for web-tier EC2 instances (desired/min/max = 0/0/0 by default)                        |
| `asg-app`       | Auto Scaling Group for app-tier EC2 instances (desired/min/max = 0/0/0 by default)                        |
| `cloudfront`    | Optional CloudFront distribution for edge caching and TLS termination (disabled by default)               |
| `dynamodb`      | Optional DynamoDB tables for application state, locking, or auxiliary data                                |
| `ec2`           | General-purpose EC2 used to build AMIs for non-internet-facing subnets (disabled by default)              |
| `iam`           | IAM roles, instance profiles, and scoped policies for services                                            |
| `nat`           | Optional NAT gateways (one per AZ) for private outbound access (disabled by default)                      |
| `rds`           | Optional RDS database provisioning with subnet groups and security integration (disabled by default)      |
| `routing`       | Custom route tables per subnet tier (public, web, app, db)                                                |
| `s3`            | S3 buckets for assets, logs, backups, or Terraform state support                                          |
| `secrets`       | Optional centralized Secrets Manager entries for app and database credentials (disabled by default)       |
| `security`      | Parameterized security group module with tier-aware rules                                                 |
| `ssm`           | Optional SSM enablement, instance registration, and command/log support (disabled by default)             |
| `subnet`        | Public, private-web, private-app, and private-db subnet definitions                                       |
| `vpc`           | VPC creation with CIDR allocation, IGW, and base networking                                               |
| `vpc_endpoints` | Gateway endpoints for S3 and DynamoDB (always on); interface endpoints handled by `ssm`/`secrets` modules |
| `waf`           | Optional AWS WAF rules and Web ACLs for ALB and CloudFront protection (disabled by default)               |

---

> Core environment modules: `vpc`, `subnet`, `routing`, `security`, `iam`, `s3`, and `vpc_endpoints`.  
> All other modules are optional and disabled by default unless explicitly enabled via variables.

## Usage

### Initial Setup and Standard Workflow

```bash
cd envs/dev/us-east-1
terraform init -backend-config="backend.hcl"
terraform fmt
terraform validate
terraform plan -out=tfplan
terraform apply "tfplan"

cd envs/test/us-east-1
terraform init -backend-config="backend.hcl"
terraform fmt
terraform validate
terraform plan -out=tfplan
terraform apply "tfplan"

cd envs/prod/us-east-1
terraform init -backend-config="backend.hcl"
terraform fmt
terraform validate
terraform plan -out=tfplan
terraform apply "tfplan"

cd envs/prod/us-west-1
terraform init -backend-config="backend.hcl"
terraform fmt
terraform validate
terraform plan -out=tfplan
terraform apply "tfplan"
```

> Optional: run `terraform init -upgrade -backend-config="backend.hcl"` when intentionally upgrading Terraform or providers.
> Do not run `terraform init -reconfigure` unless intentionally changing the backend configuration per environment or region.

To override any `default = false`, add a `-var=enable_*=true` to the `terraform plan -out=tfplan`.

For example:
```bash
cd envs/dev/us-east-1
terraform init -backend-config="backend.hcl"
terraform fmt
terraform validate
terraform plan -out=tfplan -var="enable_ec2=true"
terraform apply "tfplan"
```

This allows AWS resources that may not fall within the free tier to be enabled temporarily for evidence screenshots. After evidence screenshots are taken, rerun `terraform plan -out=tfplan` without override variables and then `terraform apply "tfplan"` to restore default values and destroy any resources that were created during the override.

## Branch Workflow

- Direct pushes to `main` are restricted
- Pull requests require approval before merging
- CI must pass before merges (format, validate, plan)
- Linear commit history enforced

## Project Roadmap (High-Level)

- [x] Bootstrap remote state and locking
- [x] Configure GitHub OIDC with IAM
- [x] Create per-env Terraform folders
- [x] Begin modular resource build-out (VPC, EC2, ALB, etc.)
- [x] Complete core infrastructure (NAT, ASG, RDS)
- [x] Add IAM policies, Secrets Manager, VPC endpoints
- [x] Implement CloudFront, WAF, and DNS edge controls
- [x] Deploy monitoring stack (logs, alarms, dashboards)
- [ ] Final testing, DR, documentation, and teardown readiness
