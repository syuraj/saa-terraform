resource "aws_codedeploy_app" "demo-app-codedeploy" {
  name             = "demo-app"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "demo-app-codedeploy-group" {
  app_name              = aws_codedeploy_app.demo-app-codedeploy.name
  deployment_group_name = "demo-app-deployment-group"
  service_role_arn      = aws_iam_role.codebuild_codedeploy_role.arn

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  ec2_tag_set {
    ec2_tag_filter {
      type  = "KEY_AND_VALUE"
      key   = "app"
      value = "demo-app"
    }
  }



  load_balancer_info {
    target_group_info {
      name = aws_lb_target_group.saa-public-lb-target-group.name
    }

    # target_group_pair_info {
    #   prod_traffic_route {
    #     listener_arns = [aws_lb_listener.saa-public-lb-listener.arn]
    #   }

    #   target_group {
    #     name = aws_lb_target_group.saa-public-lb-target-group.name
    #   }

    #   target_group {
    #     name = aws_lb_target_group.saa-public-lb-target-group.name
    #   }
    # }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM", "DEPLOYMENT_STOP_ON_REQUEST"]
  }

  #   trigger_configuration {
  #     trigger_events     = ["DeploymentFailure"]
  #     trigger_name       = "deployment-failure-trigger"
  #     trigger_target_arn = "arn:aws:sns:region:account-id:my-sns-topic"
  #   }

  #   alarm_configuration {
  #     alarms                    = ["my-alarm-name"]
  #     enabled                   = true
  #     ignore_poll_alarm_failure = false
  #   }

  deployment_config_name = "CodeDeployDefault.OneAtATime"


}

# resource "aws_codedeploy_deployment_config" "name" {
#   deployment_config_name = "ww"
# }

# resource "aws_codedeploy_deployment" "demo-app-deployment" {
#   app_name              = aws_codedeploy_app.demo-app-codedeploy.name
#   deployment_group_name = aws_codedeploy_deployment_group.demo-app-codedeploy-group.deployment_group_name

#   revision {
#     revision_type = "S3"
#     s3_location {
#       bucket = "your-s3-bucket-name"
#       key    = "path/to/your/app.zip"
#     }
#   }

#   ignore_application_stop_failures = true
# }

