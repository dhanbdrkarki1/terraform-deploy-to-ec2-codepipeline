# S3
module "s3" {
  source               = "../../modules/services/s3"
  create               = var.create_s3_remote_state
  bucket_name          = var.bucket_name
  enable_versioning    = var.enable_versioning
  force_destroy        = var.force_destroy
  create_bucket_policy = var.create_bucket_policy
  custom_tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Dynamodb
module "dynamodb" {
  source       = "../../modules/services/dynamodb"
  create       = var.create_dynamodb_table_for_state_lock
  table_name   = var.table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key
  attributes   = var.attributes
  custom_tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}


