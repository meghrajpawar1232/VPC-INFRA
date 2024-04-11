terraform {
  backend "s3" {
    #dynamodb_table = "terraform_lock"    
    bucket = "dev-devops1"
    #bucket = "salt-devops-prod"
    key = "terraform_states"
    #key = "terraform_states/STAMP_TF_states/stage.tfstate"
    #key = "terraform_states/STAMP_TF_states/prod_hk.tfstate"
    region = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
  }
}
terraform  {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}