terraform  {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}

# #Configure the AWS provider
# provider "aws" {
#   region = var.region
# }