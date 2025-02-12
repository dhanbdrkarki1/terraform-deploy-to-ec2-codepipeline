locals {
  name_prefix = "${var.custom_tags["Project"] != "" ? var.custom_tags["Project"] : "default-project"}-${var.custom_tags["Environment"] != "" ? var.custom_tags["Environment"] : "default-env"}"
}


resource "aws_codecommit_repository" "this" {
  count           = var.create ? 1 : 0
  repository_name = "${local.name_prefix}-${var.repository_name}"
  description     = var.description
  tags = merge(
    { Name = "${local.name_prefix}-${var.repository_name}" },
    var.custom_tags
  )
}
