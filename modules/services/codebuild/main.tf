locals {
  name_prefix = lower("${var.custom_tags["Project"] != "" ? var.custom_tags["Project"] : "default-project"}-${var.custom_tags["Environment"] != "" ? var.custom_tags["Environment"] : "default-env"}")
}

resource "aws_codebuild_project" "this" {
  count         = var.create ? 1 : 0
  name          = local.name_prefix
  description   = var.description
  build_timeout = 5
  service_role  = try(var.codebuild_service_role_arn, null)

  artifacts {
    type = var.build_output_artifact_type
  }

  cache {
    type     = "S3"
    location = try(var.bucket_name, null)
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.image
    type                        = var.type
    image_pull_credentials_type = var.image_pull_credentials_type
    privileged_mode             = var.privileged_mode

    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }

  dynamic "logs_config" {
    for_each = var.build_output_artifact_type != "NO_ARTIFACTS" ? [1] : []
    content {
      cloudwatch_logs {
        status     = "ENABLED"
        group_name = try(var.codebuild_log_group_name, null)
        # stream_name = aws_cloudwatch_log_stream.this[0].name
      }

      s3_logs {
        status   = "ENABLED"
        location = "${var.bucket_id}/build-log"
      }
    }
  }

  source {
    type                = var.build_project_source_type
    buildspec           = var.buildspec_file_location
    location            = var.source_location
    git_clone_depth     = var.git_clone_depth
    insecure_ssl        = var.insecure_ssl
    report_build_status = var.report_build_status

    git_submodules_config {
      fetch_submodules = var.fetch_submodules
    }

    dynamic "build_status_config" {
      for_each = var.build_status_config != null ? [var.build_status_config] : []
      content {
        context    = build_status_config.value.context
        target_url = build_status_config.value.target_url
      }
    }
  }


  tags = merge(
    { Name = "${local.name_prefix}" },
    var.custom_tags
  )
}
