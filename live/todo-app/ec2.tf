#================================
# Instance Profile
#================================
module "instance_profile" {
  source                      = "../../modules/services/iam"
  create                      = true
  create_ec2_instance_profile = true
  role_name                   = "EC2CodeDeployRole"
  role_description            = "IAM Instance role for EC2"

  # Trust relationship policy for EC2
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  # Attach managed policies
  role_policies = {
    SSMPolicy           = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    CodedeployEC2Policy = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy",
    ECRPolicy           = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  }
  custom_tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}


#================================
# App Server
#================================
module "app_server" {
  source   = "../../modules/services/ec2"
  create   = true
  name     = "server"
  ami_type = "amazon_linux2023" # Valid values: "amazon_linux2", "amazon_linux2023", "ubuntu_22", "ubuntu_24"
  #   ami_id = "ami-<id>" # Specific AMI ID to use. If provided, this will override ami_type"
  subnet_ids           = data.aws_subnets.default.ids
  availability_zones   = ["us-east-2a"]
  instance_type        = "t3.small"
  iam_instance_profile = module.instance_profile.instance_profile_name

  # Volume configuration
  volume_size               = 30
  volume_type               = "gp3"
  encrypt_ebs               = true
  delete_ebs_on_termination = true

  key_name                    = "dhan"
  security_groups_ids         = [module.web_sg.security_group_id, module.bastion_sg.security_group_id]
  associate_public_ip_address = true
  user_data_replace_on_change = true
  user_data                   = base64encode(file("${path.root}/user-data/setup-docker.sh"))
  custom_tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
