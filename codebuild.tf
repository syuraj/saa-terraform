resource "aws_codebuild_project" "demo-app-codebuild" {
  name          = "demo-app-codebuild"
  description   = "Example project that builds from GitHub source"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_codedeploy_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
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
    buildspec           = "demo-app/backend/buildspec.yml"
    git_clone_depth     = 1
    report_build_status = true
    git_submodules_config {
      fetch_submodules = false
    }
  }
  source_version = "main"

  cache {
    type = "NO_CACHE"
  }
}
