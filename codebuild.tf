resource "aws_codebuild_project" "demo-app-codebuild" {
  name          = "demo-app-codebuild"
  description   = "Example project that builds from GitHub source"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_codedeploy_role.arn

  artifacts {
    type      = "S3"
    location  = aws_s3_bucket.artifact_bucket.id
    name      = "demo-app-codebuild"
    path      = "demo-app/"
    packaging = "ZIP"
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

    environment_variable {
      name  = "CODEBUILD_CONFIG_AUTO_DISCOVER"
      type  = "PLAINTEXT"
      value = "true"
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
