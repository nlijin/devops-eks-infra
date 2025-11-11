terraform {
  backend "s3" {
    bucket         = "devops-eks-terraform-state-lijin"
    key            = "eks/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
