output "id" {
  value       = try(aws_codepipeline.this[0].id, null)
  description = "The id of the CodePipeline"
}

output "name" {
  value       = try(aws_codepipeline.this[0].name, null)
  description = "The name of the CodePipeline"
}

output "arn" {
  value       = try(aws_codepipeline.this[0].arn, null)
  description = "The arn of the CodePipeline"
}
