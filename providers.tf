provider "aws" {
  assume_role {
    role_arn     = var.assume_role
    session_name = "${var.atlantis_user}-${var.atlantis_repo_owner}-${var.atlantis_repo_name}-${var.atlantis_pull_num}"
  }
  region = var.region
}
