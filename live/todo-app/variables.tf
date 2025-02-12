#================================
# Global
#================================
variable "aws_account_id" {
  default     = null
  type        = string
  description = "AWS Account ID"
}

variable "aws_region" {
  default     = "us-east-1"
  description = "AWS Region to deploy resources"
  type        = string
}

variable "availability_zones" {
  description = "The list of availability zones names or ids in the region."
  type        = list(string)
  default     = []
}

variable "project_name" {
  description = "Name of the Project"
  type        = string
}

variable "environment" {
  description = "Environment of the project"
  default     = "test"
  type        = string
}


#================================
# CodeBuild
#================================
variable "create_codebuild" {
  default     = false
  type        = bool
  description = "Specify whether to create resource or not"
}

variable "codebuild_name" {
  type        = string
  default     = "test"
  description = "The name of the CodeBuild Project."
}

variable "codebuild_description" {
  type        = string
  default     = null
  description = "Short description of the project."
}

variable "codebuild_build_output_artifact_type" {
  description = "Build output artifact's type. Valid values: CODEPIPELINE, NO_ARTIFACTS, S3."
  type        = string
  default     = "CODEPIPELINE"
}

variable "codebuild_build_project_source_type" {
  description = "Type of repository that contains the source code to be built. Valid values: BITBUCKET, CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB_ENTERPRISE, GITLAB, GITLAB_SELF_MANAGED, NO_SOURCE, S3."
  type        = string
  default     = "CODEPIPELINE"
}

variable "codebuild_buildspec_file_location" {
  description = "The location of the buildspec.yml file."
  type        = string
  default     = "buildspec.yaml"
}

# Environment
variable "codebuild_compute_type" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "Information about the compute resources the build project will use. Available values for this parameter are: BUILD_GENERAL1_SMALL, BUILD_GENERAL1_MEDIUM, BUILD_GENERAL1_LARGE or BUILD_GENERAL1_2XLARGE. BUILD_GENERAL1_SMALL is only valid if type is set to LINUX_CONTAINER. When type is set to LINUX_GPU_CONTAINER, compute_type need to be BUILD_GENERAL1_LARGE."
}

variable "codebuild_image" {
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
  description = "The Docker image to use for this build project. Valid values include Docker images provided by CodeBuild (e.g aws/codebuild/standard:2.0), Docker Hub images (e.g. hashicorp/terraform:latest), and full Docker repository URIs such as those for ECR (e.g. 137112412989.dkr.ecr.us-west-2.amazonaws.com/amazonlinux:latest)."
}

variable "codebuild_type" {
  type        = string
  default     = "LINUX_CONTAINER"
  description = "The type of build environment to use for related builds. Available values are: LINUX_CONTAINER, LINUX_GPU_CONTAINER, WINDOWS_CONTAINER or ARM_CONTAINER."
}

variable "codebuild_image_pull_credentials_type" {
  type        = string
  default     = "CODEBUILD"
  description = "The type of credentials AWS CodeBuild uses to pull images in your build. Available values for this parameter are CODEBUILD or SERVICE_ROLE."
}

variable "codebuild_privileged_mode" {
  type        = bool
  default     = false
  description = "Whether to enable running the Docker daemon inside a Docker container."
}


#================================
# CodePipeline
#================================

variable "create_codepipeline" {
  default     = false
  type        = bool
  description = "Specify whether to create resource or not"
}

# Github Code
variable "github_repo_id" {
  description = "Source repo ID of the Github repository used as source by pipeline"
  type        = string
  default     = null
}

variable "github_repo_branch" {
  description = "Default branch in the Source repo for which CodePipeline needs to be configured"
  type        = string
  default     = null
}

variable "codestarconnection_arn" {
  description = "The ARN of the codestar connection Ato be used."
  type        = string
  default     = null
}
