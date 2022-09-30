terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.3"
    }
  }
}


provider "aws" {
  region  = var.region
  profile = var.profile
}
