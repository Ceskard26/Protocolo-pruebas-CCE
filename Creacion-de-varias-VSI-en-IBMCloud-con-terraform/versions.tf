terraform {
  required_version = ">= 1.0"
  
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~> 1.68.0"
    }
  }
  
  # Opcional: Backend para state remoto
  # backend "s3" {
  #   bucket = "tu-bucket-terraform-state"
  #   key    = "cce/terraform.tfstate"
  #   region = "us-south"
  # }
}