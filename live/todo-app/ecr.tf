module "ecr" {
  source             = "../../modules/services/ecr"
  create             = true
  name               = "todo-app-ecr"
  image_immutability = "MUTABLE" # Setting value to "MUTABLE" allowS to override image.
  force_delete       = true      # If set to true, will delete the repository even if it contains images.

  custom_tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
