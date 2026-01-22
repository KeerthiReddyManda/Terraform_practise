## Settings block 

```bash
terraform {
    #terraform version    required_providers {
         google = {
      source  = "hashicorp/google"
      version = "7.16.0"
    }
    }
}
```

## Provider block 
# Google Provider

```bash
provider "google" {
  project = "var.project_id"
  region  = "var.region"
}
```
