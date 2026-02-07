terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.14.1"
    }
  }

  backend "s3" {
    bucket  = "nextime-frame-state-bucket"
    key     = "infra-core/infra.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

}

provider "aws" {
  region = "us-east-1"
}
