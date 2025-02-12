####################
# Dynamodb
####################
locals {
  name_prefix = "${var.custom_tags["Project"] != "" ? var.custom_tags["Project"] : "default-project"}-${var.custom_tags["Environment"] != "" ? var.custom_tags["Environment"] : "default-env"}-${var.table_name != "" ? var.table_name : "table"}"
}

resource "aws_dynamodb_table" "this" {
  count        = var.create ? 1 : 0
  name         = local.name_prefix
  billing_mode = var.billing_mode
  hash_key     = var.hash_key

  dynamic "attribute" {
    for_each = try(var.attributes, null)
    content {
      name = attribute.value["name"]
      type = attribute.value["type"]
    }
  }
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.custom_tags

}
