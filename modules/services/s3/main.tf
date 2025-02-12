locals {
  name_prefix = lower(
    join("-",
      compact([
        lookup(var.custom_tags, "Project", "default"),
        lookup(var.custom_tags, "Environment", "default"),
        var.bucket_name
      ])
    )
  )
  bucket_name = try(var.bucket_name != "" ? "${local.name_prefix}" : "bucket-${random_string.bucket_suffix[0].result}", null)
  cors_rules  = try(jsondecode(var.cors_rule), var.cors_rule)
}

resource "random_string" "bucket_suffix" {
  count   = var.create ? 1 : 0
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "this" {
  count         = var.create ? 1 : 0
  bucket        = local.bucket_name
  force_destroy = var.force_destroy

  lifecycle {
    precondition {
      condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", local.bucket_name))
      error_message = "Bucket name must contain only lowercase letters, numbers, and hyphens, and must not start or end with a hyphen."
    }
    prevent_destroy = false
  }

  tags = merge(
    { "Name" = "${local.name_prefix}" },
    var.custom_tags
  )
}

resource "aws_s3_bucket_versioning" "this" {
  count  = var.create && var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.this[0].id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  count  = var.create && var.enable_ownership_controls ? 1 : 0
  bucket = aws_s3_bucket.this[0].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count = var.create && var.create_bucket_policy ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [
    aws_s3_bucket_ownership_controls.this,
    aws_s3_bucket_public_access_block.this,
  ]

  count  = var.create && var.enable_acl ? 1 : 0
  bucket = aws_s3_bucket.this[0].id
  acl    = var.bucket_acl
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.create && var.create_bucket_policy ? 1 : 0
  bucket = aws_s3_bucket.this[0].id

  policy = var.bucket_policy
  depends_on = [
    aws_s3_bucket_public_access_block.this
  ]
}

resource "aws_s3_bucket_cors_configuration" "this" {
  count = var.create && length(local.cors_rules) > 0 ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "cors_rule" {
    for_each = local.cors_rules

    content {
      id              = try(cors_rule.value.id, null)
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      allowed_headers = try(cors_rule.value.allowed_headers, null)
      expose_headers  = try(cors_rule.value.expose_headers, null)
      max_age_seconds = try(cors_rule.value.max_age_seconds, null)
    }
  }
}


