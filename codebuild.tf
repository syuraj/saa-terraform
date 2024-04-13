resource "aws_codebuild_project" "demo-app-codebuild" {
  name          = "demo-app-codebuild"
  description   = "Example project that builds from GitHub source"
  build_timeout = "5"
  service_role  = "arn:aws:iam::068852463551:role/saa-codedeploy-role"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "var.build_image"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "EXAMPLE_ENV_VAR"
      value = "example-value"
    }
  }

  source {
    type                = "GITHUB"
    location            = var.github_repo
    git_clone_depth     = 1
    report_build_status = true
  }

  cache {
    type = "NO_CACHE"
  }
}
