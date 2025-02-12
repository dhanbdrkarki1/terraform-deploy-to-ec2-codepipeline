#################################
# Elastic Container Registry
#################################

resource "aws_ecr_repository" "ecr" {
  count                = var.create ? 1 : 0
  name                 = var.name
  image_tag_mutability = var.image_immutability
  force_delete         = var.force_delete
  encryption_configuration {
    encryption_type = var.encryption_type
  }
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge(
    { "Name" = var.name },
    var.ecr_tags,
    var.custom_tags
  )
}
