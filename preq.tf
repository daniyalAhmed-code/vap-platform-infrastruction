data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "terraform_remote_state" "vap-platform-infra" {
  backend = "s3"
  config = {
    bucket = "vap-aws-terraform-remote-state-centralized"
    region = "eu-central-1"
    key    = "vap-platform-infra/eu-central-1/${var.ENV}/terraform.tfstate"
  }
}