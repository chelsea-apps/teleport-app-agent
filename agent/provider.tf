terraform {
  required_version = "> 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

variable "aws_max_retries" {
  default = 5
}
