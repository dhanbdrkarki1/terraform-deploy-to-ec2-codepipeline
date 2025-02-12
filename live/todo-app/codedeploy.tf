#================================
# CodeDeploy Service Role
#================================
module "codedeploy_service_role" {
  source           = "../../modules/services/iam"
  create           = true
  role_name        = "CodeDeployServiceRole"
  role_description = "IAM role for CodeDeploy"

  # Trust relationship policy for CodeDeploy
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  # CodeDeploy permissions policy
  role_policies = {
    S3FullAccess  = "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    CodedeployEC2 = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  }

  custom_tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}


#================================
# CodeDeploy Application
#================================
module "codedeploy" {
  source = "../../modules/services/codedeploy"
  create = true
  # App
  name             = "codedeploy"
  compute_platform = "Server" # EC2

  # Deployment Group
  deployment_config_name  = "CodeDeployDefault.AllAtOnce"
  codedeploy_service_role = module.codedeploy_service_role.role_arn

  # EC2 tag filters to identify target instances
  ec2_tag_set = [
    {
      ec2_tag_filter = [
        {
          key   = "Project"
          type  = "KEY_AND_VALUE"
          value = var.project_name
        }
      ]
    }
  ]

  # Deployment settings
  deployment_style = {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL" # if Load balancer, use WITH_TRAFFIC_CONTROL.
    deployment_type   = "IN_PLACE"
  }

  #######################################
  #** Causing AWS Provider Pluging Crash
  # Auto rollback configuration
  # auto_rollback_configuration = {
  #   enabled = true
  #   events  = ["DEPLOYMENT_FAILURE"]
  # }
  #######################################


  # # Alarm configuration (optional)
  # alarm_configuration = {
  #   enabled = true
  #   alarms  = ["deployment-alarm"]
  # }
  outdated_instances_strategy = "UPDATE"

  custom_tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
