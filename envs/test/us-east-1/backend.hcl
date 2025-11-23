# envs/test/us-east-1/backend.hcl

bucket          = "ffd-tfstate-7714022395766-us-east-1"
key             = "envs/test/terraform.tfstate"
region          = "us-east-1"
dynamodb_table  = "ffd-tf-lock"
