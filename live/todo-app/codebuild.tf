#================================
# CodeBuild S3
#================================
module "codebuild_artifact_bucket" {
  source               = "../../modules/services/s3"
  create               = true
  bucket_name          = "codebuild-logs"
  enable_versioning    = true
  force_destroy        = true
  create_bucket_policy = true
  bucket_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "codebuild.amazonaws.com"
        },
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:ListBucket",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ],
        "Resource" : [
          "${module.codebuild_artifact_bucket.bucket_arn}",
          "${module.codebuild_artifact_bucket.bucket_arn}/*"
        ]
      }
    ]
  })

  custom_tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

#================================
# CodeBuild Log Group
#================================
module "codebuild_log_group" {
  source            = "../../modules/services/cloudwatch"
  create            = true
  name              = "/aws/codebuild/${var.project_name}-${var.environment}"
  retention_in_days = 30

  custom_tags = {
    Name        = "/aws/codebuild/${var.project_name}-${var.environment}"
    Environment = var.environment
  }
}

#================================
# CodeBuild Service Role and Policy
#================================
module "codebuild_service_role" {
  source           = "../../modules/services/iam"
  create           = true
  role_name        = "CodeBuildServiceRole"
  role_description = "IAM role for CodeBuild"

  # Trust relationship policy for CodeBuild
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  # CodeBuild permissions policy
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # S3 permissions
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
        Resource = [
          module.codebuild_artifact_bucket.bucket_arn,
          "${module.codebuild_artifact_bucket.bucket_arn}/*",
          "${module.codepipeline_artifact_bucket.bucket_arn}/*"
        ]
      },
      # CloudWatch Logs permissions
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = [
          "${try(module.codebuild_log_group.log_group_arn, "*")}",
          "${try(module.codebuild_log_group.log_group_arn, "*")}:*"
        ]
      },
      # CodeBuild permissions
      {
        Effect = "Allow"
        Action = [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ]
        Resource = try(module.codebuild.arn, "*")
      },
      # CodeConnection Permssions
      {
        Effect = "Allow"
        Action = [
          "codeconnections:GetConnectionToken",
          "codeconnections:GetConnection",
          "codeconnections:UseConnection"
        ]
        Resource = try(var.codeconnection_arn, "*")
      },
      # ECR Permissions
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = try(module.ecr.arn, "*")
      }
    ]
  })

  custom_tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}


module "codebuild" {
  source      = "../../modules/services/codebuild"
  create      = var.create_codebuild
  name        = var.codebuild_name
  description = var.codebuild_description

  # IAM Role
  codebuild_service_role_arn = module.codebuild_service_role.role_arn

  # Artifact Bucket
  bucket_name = module.codebuild_artifact_bucket.bucket_name
  bucket_id   = module.codebuild_artifact_bucket.bucket_id

  # Log group
  codebuild_log_group_name = module.codebuild_log_group.log_group_name


  // For testing, set build_output_artifact_type = "NO_ARTIFACTS", build_project_source_type = "NO_SOURCE" and comment source_location.
  // For production, set build_output_artifact_type = "CODEPIPELINE" and build_project_source_type = "CODEPIPELINE"

  # Artifact
  build_output_artifact_type = var.codebuild_build_output_artifact_type

  # source
  build_project_source_type = var.codebuild_build_project_source_type
  buildspec_file_location   = var.codebuild_buildspec_file_location
  source_location           = "https://github.com/dhan-cloudtech/nodejs-apps-multi.git"
  git_clone_depth           = 1
  report_build_status       = true
  fetch_submodules          = true

  build_status_config = {
    context    = "continuous-integration/codebuild"
    target_url = "https://console.aws.amazon.com/codebuild/home"
  }

  # Environment
  compute_type                = var.codebuild_compute_type
  image                       = var.codebuild_image
  type                        = var.codebuild_type
  image_pull_credentials_type = var.codebuild_image_pull_credentials_type
  privileged_mode             = var.codebuild_privileged_mode
  environment_variables = [
    # ECR Repo
    {
      name  = "REPOSITORY_URI"
      value = module.ecr.repository_url
      type  = "PLAINTEXT"
    },
    {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
      type  = "PLAINTEXT"
    },
    {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
      type  = "PLAINTEXT"
    },
    {
      name  = "DockerFilePath"
      value = "Dockerfile"
      type  = "PLAINTEXT"
    },
    {
      name  = "CONTAINER_NAME"
      value = var.project_name
      type  = "PLAINTEXT"
    }
  ]

  custom_tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
