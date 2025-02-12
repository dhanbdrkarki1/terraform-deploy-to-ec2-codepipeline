output "id" {
  value       = try(aws_codebuild_project.this[0].id, null)
  description = "The ID of the CodeBuild projects"
}

output "name" {
  value       = try(aws_codebuild_project.this[0].name, null)
  description = "The Names of the CodeBuild projects"
}

output "arn" {
  value       = try(aws_codebuild_project.this[0].arn, null)
  description = "The ARNs of the CodeBuild projects"
}
