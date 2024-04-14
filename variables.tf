
variable "aws_region" {
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  type        = string
  default     = "068852463551"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "https://github.com/syuraj/saa-terraform.git"
}

# variable "github_branch" {
#   description = "GitHub repository branch"
#   type        = string
#   default     = "main"
# }
