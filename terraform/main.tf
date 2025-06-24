# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

# Amplify App
resource "aws_amplify_app" "spa_app" {
  name       = var.app_name
  repository = var.github_repository

  # GitHub access token for private repos
  access_token = var.github_access_token

  # Build settings for SPA
  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: dist
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  # Custom rules for SPA routing (handles client-side routing)
  custom_rule {
    source = "/<*>"
    status = "404-200"
    target = "/index.html"
  }

  # Environment variables (optional)
  environment_variables = {
    NODE_ENV = "dev"
    # Add other environment variables as needed
  }

  # Enable auto branch creation
  enable_auto_branch_creation = false
  enable_branch_auto_build    = true

  tags = {
    Environment = "dev"
    Project     = var.app_name
  }
}

# Branch configuration
resource "aws_amplify_branch" "main_branch" {
  app_id      = aws_amplify_app.spa_app.id
  branch_name = var.branch_name

  # Enable auto build
  enable_auto_build = true

  # Environment variables specific to this branch
  environment_variables = {
    BRANCH = var.branch_name
  }

  tags = {
    Environment = "dev"
    Branch      = var.branch_name
  }
}

# Domain association (optional - for custom domain)
resource "aws_amplify_domain_association" "custom_domain" {
  count       = var.custom_domain != "" ? 1 : 0
  app_id      = aws_amplify_app.spa_app.id
  domain_name = var.custom_domain

  sub_domain {
    branch_name = aws_amplify_branch.main_branch.branch_name
    prefix      = ""
  }

  # Optional: www subdomain
  sub_domain {
    branch_name = aws_amplify_branch.main_branch.branch_name
    prefix      = "www"
  }
}



