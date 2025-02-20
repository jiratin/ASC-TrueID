variable "atlantis_user" {
  default     = ""
  type        = string
  description = "Atlantis will auto inject value for this variable"
}

variable "atlantis_repo_owner" {
  default     = ""
  type        = string
  description = "Atlantis will auto inject value for this variable"
}

variable "atlantis_repo_name" {
  default     = ""
  type        = string
  description = "Atlantis will auto inject value for this variable"
}

variable "atlantis_pull_num" {
  default     = ""
  type        = string
  description = "Atlantis will auto inject value for this variable"
}

variable "assume_role" {
  type        = string
  description = "IAM Role that can be assume to other account"
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket to create"
}

variable "region" {
  type        = string
  default     = "ap-southeast-1"
  description = "The AWS region to deploy infrastructure to"
}
