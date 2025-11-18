# envs/prod/backend.hcl

bucket          = "ffd-tfstate-7714022395766-us-east-1"
key             = "envs/prod/terraform.tfstate"
region          = "us-east-1"
dynamodb_table  = "ffd-tf-lock"
