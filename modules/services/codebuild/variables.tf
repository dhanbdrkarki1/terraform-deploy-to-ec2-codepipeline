####################
# AWS CodeBuild
####################

variable "create" {
  default     = false
  type        = bool
  description = "Specify whether to create resource or not"
}

variable "name" {
  type        = string
  default     = "test"
  description = "The name of the CodeBuild Project."
}

variable "description" {
  type        = string
  default     = "description"
  description = "Short description of the project."
}

# Environment
variable "compute_type" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "Information about the compute resources the build project will use. Available values for this parameter are: BUILD_GENERAL1_SMALL, BUILD_GENERAL1_MEDIUM, BUILD_GENERAL1_LARGE or BUILD_GENERAL1_2XLARGE. BUILD_GENERAL1_SMALL is only valid if type is set to LINUX_CONTAINER. When type is set to LINUX_GPU_CONTAINER, compute_type need to be BUILD_GENERAL1_LARGE."
}

variable "image" {
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
  description = "The Docker image to use for this build project. Valid values include Docker images provided by CodeBuild (e.g aws/codebuild/standard:2.0), Docker Hub images (e.g. hashicorp/terraform:latest), and full Docker repository URIs such as those for ECR (e.g. 137112412989.dkr.ecr.us-west-2.amazonaws.com/amazonlinux:latest)."
}

variable "type" {
  type        = string
  default     = "LINUX_CONTAINER"
  description = "The type of build environment to use for related builds. Available values are: LINUX_CONTAINER, LINUX_GPU_CONTAINER, WINDOWS_CONTAINER or ARM_CONTAINER."
}

variable "image_pull_credentials_type" {
  type        = string
  default     = "CODEBUILD"
  description = "The type of credentials AWS CodeBuild uses to pull images in your build. Available values for this parameter are CODEBUILD or SERVICE_ROLE."
}

variable "privileged_mode" {
  type        = bool
  default     = false
  description = "Whether to enable running the Docker daemon inside a Docker container."
}

variable "environment_variables" {
  description = "Environment variables for the build environment"
  type = list(object({
    name  = string
    value = string
    type  = string
  }))
  default = []
}

# Repository
variable "repo_type" {
  type        = string
  default     = "GITHUB"
  description = "Type of repository that contains the source code to be built. Valid values: BITBUCKET, CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB_ENTERPRISE, GITLAB, GITLAB_SELF_MANAGED, NO_SOURCE, S3."
}

variable "repo_location" {
  type        = string
  default     = null
  description = "Location of the source code from git or s3."
}

variable "source_version" {
  type        = string
  default     = "master"
  description = "A version of the build input to be built for this project. If not specified, the latest version is used."
}

variable "build_output_artifact_type" {
  description = "Build output artifact's type. Valid values: CODEPIPELINE, NO_ARTIFACTS, S3."
  type        = string
  default     = "CODEPIPELINE"
}

variable "build_project_source_type" {
  description = "Type of repository that contains the source code to be built. Valid values: BITBUCKET, CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB_ENTERPRISE, GITLAB, GITLAB_SELF_MANAGED, NO_SOURCE, S3."
  type        = string
  default     = "CODEPIPELINE"
}

variable "buildspec_file_location" {
  description = "The location of the buildspec.yml file."
  type        = string
  default     = "buildspec.yaml"
}


variable "source_location" {
  description = "Location of the source code"
  type        = string
  default     = null
}

variable "git_clone_depth" {
  description = "Git clone depth. Valid values between 0 and 100"
  type        = number
  default     = 1
}

variable "insecure_ssl" {
  description = "Ignore SSL warnings when connecting to source control"
  type        = bool
  default     = false
}

variable "report_build_status" {
  description = "Report build status back to source provider"
  type        = bool
  default     = false
}

variable "fetch_submodules" {
  description = "Whether to fetch Git submodules"
  type        = bool
  default     = false
}

variable "source_auth" {
  description = "Authentication configuration for source provider"
  type = object({
    type     = string
    resource = string
  })
  default = null
}

variable "build_status_config" {
  description = "Build status configuration"
  type = object({
    context    = string
    target_url = string
  })
  default = null
}



# IAM Role
variable "codebuild_service_role_arn" {
  type        = string
  description = "The ARN of the IAM role that enables AWS CodeBuild to interact with dependent AWS services on behalf of the AWS account."
  default     = null

}

# S3 Bucket
# Used for Logs and Cache
variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket where the build output artifacts will be stored."
  default     = null
}

variable "bucket_id" {
  type        = string
  description = "The id of the S3 bucket where the build output artifacts will be stored. Used by s3_logs block"
  default     = null
}

# CloudWatch Log Group
variable "codebuild_log_group_name" {
  type        = string
  default     = null
  description = "The name of the CloudWatch log group where the build logs will be stored. Used by cloudwatch_logs block"
}


variable "custom_tags" {
  description = "Custom tags to be applied to the codebuild project"
  type        = map(string)
  default     = {}
}
