variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "aws_profile" {
  description = "AWS CLI profile name"
  default     = "default"
}

variable "cluster_name" {
  description = "EKS cluster name"
  default     = "devops-eks-demo"
}

variable "node_instance_type" {
  description = "EC2 instance type for nodes"
  default     = "t3.medium"
}
