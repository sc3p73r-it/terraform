provider "aws" {
 profile = "default"
    default_tags {
      tags = {
        Managed_by = "Terraform"
      }
    }
}