terraform {
  backend "s3" {
    bucket       = "devops-eks-terraform-state-lijin"
    key          = "eks/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}
