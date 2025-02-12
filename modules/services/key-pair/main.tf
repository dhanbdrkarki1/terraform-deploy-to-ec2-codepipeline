locals {
  create = var.create ? 1 : 0
  name_prefix = "${var.custom_tags["Project"] != "" ? var.custom_tags["Project"] : "default-project"}-${var.custom_tags["Environment"] != "" ? var.custom_tags["Environment"] : "default-env"}-${var.key_name != "" ? var.key_name : "default-name"}"
}

# automatically generate private key (not good for production)
resource "tls_private_key" "web-key" {
  count = local.create
  algorithm   = var.algorithm_type
  rsa_bits = 4096
}

#  upload the public key to AWS
resource "aws_key_pair" "generated_key" {
  count = local.create
  key_name   = var.key_name
  public_key = tls_private_key.web-key[0].public_key_openssh
  tags = merge(
    { "Name" = "${local.name_prefix}" },
    var.custom_tags
  )
}

# save key to local file
resource "local_file" "web-test" {
  count = local.create
  content  = tls_private_key.web-key[0].private_key_pem
  filename = "${var.dir}/${var.key_name}.pem"
  file_permission = 0400
}




