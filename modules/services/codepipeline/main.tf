locals {
  name_prefix = lower("${var.custom_tags["Project"] != "" ? var.custom_tags["Project"] : "default-project"}-${var.custom_tags["Environment"] != "" ? var.custom_tags["Environment"] : "default-env"}")
}

resource "aws_codepipeline" "this" {
  count          = var.create ? 1 : 0
  name           = "${local.name_prefix}-pipeline"
  role_arn       = try(var.codepipeline_service_role_arn, null)
  pipeline_type  = var.pipeline_type
  execution_mode = var.pipeline_execution_mode

  artifact_store {
    location = try(var.codepipeline_artifact_bucket, null)
    type     = "S3"
    dynamic "encryption_key" {
      for_each = var.enable_kms_encryption ? [1] : []
      content {
        id   = try(var.kms_encryption_key_arn, null)
        type = "KMS"
      }
    }
  }

  dynamic "stage" {
    for_each = var.stages
    content {
      name = stage.value.name
      action {
        name             = stage.value.action.name
        category         = stage.value.action.category
        owner            = stage.value.action.owner
        provider         = stage.value.action.provider
        version          = stage.value.action.version
        configuration    = stage.value.action.configuration
        input_artifacts  = lookup(stage.value.action, "input_artifacts", [])
        output_artifacts = lookup(stage.value.action, "output_artifacts", [])
        run_order        = lookup(stage.value.action, "run_order", null)
      }
    }
  }

  tags = merge(
    { Name = "${local.name_prefix}-pipeline" },
    var.custom_tags
  )
}
