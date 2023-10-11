terraform {
  backend "s3" {
    bucket = "ulanbek-12345678"
    key    = "kaizenai/terraform.tfstate"
    region = "us-east-1"
    #dynamodb_table = "lock-state"
  }
}

#####  we have to create our S3 backet manually "don't forget to enable version" in AWS-Console with uniuq name and provide this name in Backend.tf file    sudo nano /etc/gitlab/initial_root_password