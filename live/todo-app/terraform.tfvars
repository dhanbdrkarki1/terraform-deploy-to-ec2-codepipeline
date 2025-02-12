#================================
# Global
#================================
project_name       = "dhan-todos"
environment        = "dev"
aws_region         = "us-east-2"
availability_zones = ["us-east-2a", "us-east-2b"]
aws_account_id     = "664418970145"
#================================
# CodeBuild
#================================
create_codebuild      = true
codebuild_name        = "codebuild"
codebuild_description = "This is codebuild."

// For testing, set build_output_artifact_type = "NO_ARTIFACTS" and build_project_source_type = "NO_SOURCE"
// For production, set build_output_artifact_type = "CODEPIPELINE" and build_project_source_type = "CODEPIPELINE"

# Artifact
codebuild_build_output_artifact_type = "CODEPIPELINE"

# source
codebuild_build_project_source_type = "CODEPIPELINE"

codebuild_buildspec_file_location = "buildspec.yml" # file from the codecommit repo.

# Environment
codebuild_compute_type                = "BUILD_GENERAL1_SMALL"
codebuild_image                       = "aws/codebuild/standard:7.0"
codebuild_type                        = "LINUX_CONTAINER"
codebuild_image_pull_credentials_type = "CODEBUILD"
codebuild_privileged_mode             = false


#================================
# CodePipeline
#================================
create_codepipeline = true
github_repo_id      = "dhan-cloudtech/todo-with-auth"
github_repo_branch  = "main"
codeconnection_arn  = "arn:aws:codeconnections:us-east-2:664418970145:connection/717bcd81-1735-42a5-a28e-05cf28d02c7c"
