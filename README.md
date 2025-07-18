# terraform-ai-agent-guidelines

This repository contains Terraform configuration for AWS infrastructure. The `envs/dev` workspace demonstrates initializing AWS credentials via a named profile.

## Using an AWS profile

Configure your AWS credentials using the AWS CLI:

```bash
aws configure --profile myprofile
```

Then run the Terraform workflows with:

```bash
make init dir=envs/dev
make validate dir=envs/dev
```

Set the `profile` variable when planning:

```bash
terraform -chdir=envs/dev plan -var="profile=myprofile" -var="region=us-east-1"
```