# terraform-multi-env-project
Terraform project that builds 3 AWS environments (dev, stg, prd) from one reusable module. Creates EC2, S3 and DynamoDB in ap-south-1 with env-prefixed names, a remote S3 backend and state locking (use_lockfile).
