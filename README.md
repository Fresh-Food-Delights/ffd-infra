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

| Resource Type       | Purpose                                                                  |
|---------------------|--------------------------------------------------------------------------|
| S3 Buckets          | `ffd-tfstate-*`, `ffd-artifacts-*`, `ffd-logs-*` for state, builds, logs |
| DynamoDB            | `ffd-tf-lock` for Terraform backend state locking                        |
| IAM                 | OIDC trust for GitHub Actions + scoped policies                          |
| VPC + Subnets       | Isolated tiers for Web, App, and DB in each environment                  |
| ALB, EC2, RDS       | Core infrastructure components for application and DB tiers              |
| VPC Endpoints       | S3, DynamoDB, Secrets Manager, SSM, etc. with least privilege            |
| Future:             | CloudFront, WAF, GuardDuty, CloudTrail, etc. (planned for deployment)    |

## 🗂 Repository Structure

```
FFD-INFRA/
├── .github/             # GitHub Actions workflows
│   └── workflows/
│       └── terraform.yml
├── diagram/             # Reference architecture visuals
│   └── diagram.jpg
├── envs/                # Environment-specific configuration
│   ├── dev/
│   ├── test/
│   └── prod/
├── modules/             # All Terraform modules used by environments
│   ├── alb-app/         # Private ALB targeting app tier (8080)
│   ├── alb-web/         # Public ALB targeting web tier (80)
│   ├── asg-app/         # App-tier Auto Scaling Group
│   ├── asg-web/         # Web-tier Auto Scaling Group
│   ├── ec2/             # Reusable EC2 launch configuration (free tier)
│   ├── iam/             # IAM role/policy bindings (placeholder)
│   ├── nat/             # AZ-mapped NAT gateways
│   ├── rds/             # Placeholder for PostgreSQL or read replica module
│   ├── routing/         # Route tables per subnet tier (no broad local)
│   ├── security/        # Security groups with customizable rules
│   ├── ssm/             # SSM session support and output for EC2 targets
│   ├── subnet/          # Tiered subnet layout (per AZ)
│   ├── vpc/             # Core VPC and IGW creation
│   ├── vpc_endpoints/   # S3, DynamoDB, SSM, Secrets, KMS endpoints
│   └── waf/             # Placeholder for AWS WAF module
├── policies/            # S3 and IAM policy JSON files
│   ├── artifacts-policy.json
│   ├── logs-policy.json
│   ├── ownership.json
│   ├── public-block.json
│   ├── sse.json
│   └── tfstate-policy.json
├── backend.hcl          # Shared backend config for remote state
├── providers.tf         # Terraform provider configuration
├── .gitignore
└── README.md
```

---

## 🔧 Module Overview

| Module         | Purpose                                                     |
|----------------|-------------------------------------------------------------|
| `alb-web`      | Public ALB for web tier (HTTP 80)                           |
| `alb-app`      | Internal ALB for app tier (HTTP 8080)                       |
| `asg-web`      | Auto Scaling Group for web-tier EC2                         |
| `asg-app`      | Auto Scaling Group for app-tier EC2                         |
| `ec2`          | General-purpose EC2 instance launcher                       |
| `nat`          | One NAT gateway per AZ (disabled by default)                |
| `routing`      | Custom route tables per subnet tier                         |
| `security`     | Parameterized security group module                         |
| `ssm`          | SSM activation and output capture for EC2 usage             |
| `subnet`       | Public, private-web, private-app, and private-db subnets    |
| `vpc`          | VPC creation and IGW                                        |
| `vpc_endpoints`| Gateway and interface endpoints for AWS services            |

---

## Usage

### Initial Setup

```bash
cd envs/dev
terraform init -backend-config="backend.hcl"
```

> Do not run `terraform init -reconfigure` unless intentionally changing the backend configuration.

### Standard Workflow

```bash
terraform fmt
terraform validate
terraform plan
terraform apply
```

## Branch Workflow

- All work is performed in feature branches
- Direct pushes to `main` are restricted
- Pull requests require approval before merging
- CI must pass before merges (format, validate, plan)
- Linear commit history enforced

## Project Roadmap (High-Level)

- [x] Bootstrap remote state and locking
- [x] Configure GitHub OIDC with IAM
- [x] Create per-env Terraform folders
- [x] Begin modular resource build-out (VPC, EC2, ALB, etc.)
- [ ] Complete core infrastructure (NAT, ASG, RDS)
- [ ] Add IAM policies, Secrets Manager, VPC endpoints
- [ ] Implement CloudFront, WAF, and DNS edge controls
- [ ] Deploy monitoring stack (logs, alarms, dashboards)
- [ ] Final testing, DR, documentation, and teardown readiness

