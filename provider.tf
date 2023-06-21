#Terraform Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "AKIAXIAM7HV5SK7QZ6OT"
  secret_key = "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"
}

