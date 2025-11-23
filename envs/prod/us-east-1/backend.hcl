# envs/prod/us-east-1/backend.hcl

bucket          = "ffd-tfstate-7714022395766-us-east-1"
key             = "envs/prod/us-east-1/terraform.tfstate"
region          = "us-east-1"
dynamodb_table  = "ffd-tf-lock"
