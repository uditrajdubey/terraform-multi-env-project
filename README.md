# Terraform Multi-Environment AWS Project

Build 3 AWS environments (**dev, stg, prd**) from **one reusable Terraform module**.

Same code, different values. A fourth environment takes one new module block.

---

## What gets created

| Environment | EC2 | S3 | DynamoDB | OS (AMI) |
|-------------|-----|----|----------|----------|
| dev | 2 | 1 | 1 | Ubuntu |
| stg | 1 | 1 | 1 | Amazon Linux |
| prd | 1 | 1 | 1 | Red Hat |

- Region: `ap-south-1`
- Instance type: `t3.micro`
- Total: 28 resources across all environments

---

## Project structure

```
terraform-with-project
├── main.tf                  # calls the module once per environment
├── provider.tf              # AWS provider
├── terraform.tf             # Terraform version + S3 remote backend
└── custom_infra_aws         # reusable module
    ├── custom_ec2.tf
    ├── custom_s3.tf
    ├── custom_dynamodb.tf
    ├── custom_variable.tf
    └── terra-automate-key.pub
```

---

## How it works

```
main.tf ──► module "dev-infra"  ─┐
        ──► module "stg-infra"  ─┼──► custom_infra_aws ──► EC2 + S3 + DynamoDB
        ──► module "prd-infra"  ─┘
```

1. EC2, S3 and DynamoDB are written once inside the module.
2. The module takes 4 variables:

| Variable | Purpose |
|----------|---------|
| `custom_env` | Environment name (dev / stg / prd) |
| `ec2_ami_id` | AMI used for the EC2 instances |
| `ec2_count` | Number of EC2 instances |
| `ec2_type` | Instance type (`t3.micro`) |

3. Every resource name uses the env prefix, so environments never collide:
   `"${var.custom_env}-my-dynamodb-table"`
4. EC2 uses `count = var.ec2_count`, so one block creates 1 or 2 servers.
5. `main.tf` calls the module once per environment:

```hcl
module "dev-infra" {
  source     = "./custom_infra_aws"
  custom_env = "dev"
  ec2_ami_id = "ami-..."
  ec2_count  = 2
  ec2_type   = "t3.micro"
}
```

---

## Remote backend and state locking

- State is stored in an S3 bucket.
- Locking is enabled with `use_lockfile = true` in the backend block.
- If two operations run at once, the second fails with `Error acquiring the state lock`.

---

## Prerequisites

- Terraform installed
- AWS CLI configured (`aws configure`)
- An S3 bucket for the remote state, already created
- Your AMI IDs and bucket name filled in `main.tf` and `terraform.tf`

---

## Usage

Run these one at a time from the project root.

Initialize:

```bash
terraform init
```

Validate:

```bash
terraform validate
```

Preview the changes:

```bash
terraform plan
```

Create the infrastructure:

```bash
terraform apply
```

Verify the resources in the AWS console, then clean up.

---

## Clean up

```bash
terraform destroy
```

> Always destroy when you are done. AWS keeps billing for resources you forget about.

---

## Key takeaway

Modules plus variables turn copy-paste into reuse.

---

## Author

**Udit Raj Dubey**
[GitHub](https://github.com/uditrajdubey) · https://www.linkedin.com/in/udit-raj-dubey-0a551528a/?isSelfProfile=true .

Part of my #90DaysOfDevops journey.
