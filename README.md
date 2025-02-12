# Terraform for AWS Infrastructure and Pipeline

## Overview

This project includes different modules to setup AWS Infrastructure and AWS CI/CD pipeline.

Modules included:

- CodeDeploy
- CodePipeline
- CodeBuild
- CloudWatch
- DynamoDB
- ECR
- EC2
- IAM
- S3
- Security Groups
- SNS

## Prerequisites

- Terraform installed. [Install Terraform](https://developer.hashicorp.com/terraform/install).
- AWS CLI configured with appropriate credentials. [AWS CLI Configuration](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions).

## Setting Up the AWS Profile (Optional)

**If you don't already have an AWS profile configured, follow these steps:**

1. **Configure the AWS profile using the AWS CLI:**

   Open your terminal and run the following command, replacing `YOUR_PROFILE_NAME`, `YOUR_ACCESS_KEY_ID`, `YOUR_SECRET_ACCESS_KEY`, and `DEFAULT_REGION` with your actual AWS credentials:

   ```bash
   aws configure --profile YOUR_PROFILE_NAME \
       --access-key-id YOUR_ACCESS_KEY_ID \
       --secret-access-key YOUR_SECRET_ACCESS_KEY \
       --region DEFAULT_REGION
   ```

## Setup

### 1. Clone the Repository

Clone the repository to your local machine:

```bash
git clone https://github.com/dhan-cloudtech/codepipeline-cicd-docker.git
cd codepipeline-cicd-docker/
```

### 2. Creating S3 Bucket for Terraform Remote State Management

```bash
cd codepipeline-cicd-docker/remote-state/todo-app
```

Update providers.tf file:

```
provider "aws" {
  region  = "<aws_account_region-e.g. us-east-1>"
  profile = "<YOUR_PROFILE_NAME>"
  default_tags {
    tags = {
      OwnedBy    = "<Name of the Owner>"
      Department = "<Name of the Department>"
      ManagedBy  = "Terraform"
      // can add more tags here...
    }
  }
}
```

Update terraform.tfvars file:

```
bucket_name = "<Name_of_the_S3_Bucket_for_remote_state>"
table_name  = "<Name_of_the_DynamoDb_Table_for_state_locking>"
```

To create s3 bucket and dynamodb table,

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

### 3. Creating Infrastructure

Before creating infrastructure, take these steps into consideration:

#### Update provider.hcl

Navigate to,

```bash
cd codepipeline-cicd-docker/todo-app
```

Update the providers.tf with the above created bucket name and dynamodb table, displayed in terraform console output and AWS profile.

```bash
profile = "<YOUR_PROFILE_NAME>"
region         = "<aws_account_region>"
bucket = "<Name_of_the_S3_Bucket_for_remote_state>"
dynamodb_table  = "<Name_of_the_DynamoDb_Table_for_state_locking>"
```

#### Customizing the Infrastructure

To change the resource attributes,
use main.tf, pipeline.tf and other .tf file in the root module.

For example, if you want to change the name of the ec2, go to ec2.tf "ec2" module block and update name:

```
name                       = "<Desired VPC Name>"
...
```

Likewise, you can modify for other resources.

#### Running Infrastructure

This project uses Terraform apply command to provision infrastructure across all modules.

```bash
terraform init
terraform plan
terraform apply
```

## Destroying Infrastructure Resources (Optional)

⚠️ Be careful with this destructive command since this destroy all the existing infrastructure in AWS.

```bash
terraform destroy -auto-approve
```
