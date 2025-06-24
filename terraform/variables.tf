variable "github_repository" {
  description = "GitHub repository URL"
  type        = string
}

variable "github_access_token" {
  description = "GitHub personal access token"
  type        = string
  sensitive   = true
}

variable "app_name" {
  description = "Name of the Amplify application"
  type        = string
  default     = "spa-demo-app"
}

variable "branch_name" {
  description = "Git branch to deploy"
  type        = string
  default     = "main"
}

variable "custom_domain" {
  description = "Custom domain name (optional)"
  type        = string
  default     = ""
}