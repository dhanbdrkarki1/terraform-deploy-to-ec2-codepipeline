output "key_name"{
  value = try(aws_key_pair.generated_key[0].key_name, null)
}

output "pem_key_file_path" {
  value = try(local_file.web-test[0].filename, null)
}