#================================
# Global
#================================
project_name = "dhan-todos"
environment  = "dev"
aws_region   = "us-east-2"

####################
# S3 - Remote Stage Management
####################
create_s3_remote_state = true
bucket_name            = "remote-state"
enable_versioning      = true
force_destroy          = true
create_bucket_policy   = false

####################
# Dyanmodb Table
####################
create_dynamodb_table_for_state_lock = true
table_name                           = "terraform-state-lock"
billing_mode                         = "PAY_PER_REQUEST"
hash_key                             = "LockID"
attributes = [
  {
    name = "LockID"
    type = "S"
  }
]
