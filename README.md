# terraform-module-project


## Usage:

```hcl
module "project" {
    source = "Ulan8888/project/module"
    version = "0.0.7"
    region = "us-east-1"
    vpc_cidr = "10.0.0.0/16"
    subnet_cidr1 = "10.0.101.0/24"
    subnet_cidr2 = "10.0.2.0/24"
    subnet_cidr3 = "10.0.3.0/24"
    az1 = "us-east-1a"
    az2 = "us-east-1b"
    az3 = "us-east-1c"
    ip_on_launch = true
    instance_type = "t2.xlarge"
    bucket  =  "ulanbek-12345678"
    key     =  "virginia-key"
}
```


<!-- Terraform Infrastructure Deployment and Module Publication
Part 1: Deploy Infrastructure
Overview
This documentation provides step-by-step instructions for deploying infrastructure using Terraform. The deployment includes creating a VPC, subnets, route table, internet gateway, security group, and an EC2 instance. Additionally, the code is made dynamic with variables and tfvars, a Makefile is included to streamline the deployment process, and the statefile is stored in a remote backend.
Deployment Steps
Step 1: Create a VPC
Create a VPC with a specific name and configure it with your desired CIDR block. Create a file named vpc.tf:
provider aws {
region = var.region
}
resource "aws_vpc" "group2" {
cidr_block = var.vpc_cidr
tags = {
Name = "group2"
}

Step 2: Create Subnets
Create three subnets within the VPC, each in a different Availability Zone. Create a subnets.tf file:
resource "aws_subnet" "subnet1" {
vpc_id = aws_vpc.group2.id
cidr_block = var.subnet_cidr1
availability_zone = var.az1
map_public_ip_on_launch = var.ip_on_launch
tags = {
Name = "Group2"
}
}
resource "aws_subnet" "subnet2" {
vpc_id = aws_vpc.group2.id
cidr_block = var.subnet_cidr2
availability_zone = var.az2
map_public_ip_on_launch = var.ip_on_launch
tags = {
Name = "Group2"
}
}
resource "aws_subnet" "subnet3" {
vpc_id = aws_vpc.group2.id
cidr_block = var.subnet_cidr3
availability_zone = var.az3
map_public_ip_on_launch = var.ip_on_launch
tags = {
Name = "Group2"
}
}
Step 3: Create a Route Table and Internet Gateway
Create a route table and associate it with the VPC, and then create an Internet Gateway and associate it with the VPC. Create a network.tf file:
resource "aws_internet_gateway" "gw" {
vpc_id = aws_vpc.group2.id
tags = {
Name = "group2"
}
}
resource "aws_route_table" "example" {
vpc_id = aws_vpc.group2.id
route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.gw.id
}
tags = {
Name = "group2"
}
}


Step 4: Create a Security Group
Create a security group allowing the required ports for your application. Create a security.tf file:
resource "aws_security_group" "allow_tls" {
name = "group2"
description = "Allow TLS inbound traffic"
vpc_id = aws_vpc.group2.id
ingress {
description = "TLS from VPC"
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
ingress {
description = "TLS from VPC"
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
tags = {
Name = "group2"
}
}
Step 5:Define variables to make code more dynamic. Create a  variables.tf
variable region {
    type = string
    default = ""
}
variable vpc_cidr {
    type = string
    default = ""
}
variable subnet_cidr1 {
    type = string
    default = ""
}
variable subnet_cidr2 {
    type = string
    default = ""
}
variable subnet_cidr3 {
    type = string
    default = ""
}
variable az1 {
    type = string
    default = ""
}
variable az2 {
    type = string
    default = ""
}
variable az3 {
    type = string
    default = ""
}
variable ip_on_launch {
    type = bool
    default = true
}
variable key_name {
  type        = string
  default     = ""
  description = "Enter a key name"
}
variable az {
    type = string
    default = ""
}
variable bucket {
    type = string
    default = ""
}
variable key {
    type = string
    default = ""
}

Step 6.  Launch EC2 Instance
Launch an EC2 instance with the desired AMI image, security group, and subnet. Create an ec2.tf file:
data "aws_ami" "ubuntu" {
most_recent = true
filter {
name = "name"
values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
}
filter {
name = "virtualization-type"
values = ["hvm"]
}
owners = ["099720109477"] # Canonical
}
resource "aws_instance" "web" {
ami = data.aws_ami.ubuntu.id
instance_type = "t2.xlarge"
availability_zone = var.az
# vpc_id = aws_vpc.group-Number.id
vpc_security_group_ids = [aws_security_group.allow_tls.id]
key_name = aws_key_pair.deployer1.key_name
subnet_id = aws_subnet.subnet1.id # subnet_id = aws_subnet.main1.id
user_data = file("gitlab.sh")
}
output ec2 {
value = aws_instance.web.public_ip
}
# resource "aws_key_pair" "deployer1" {
# key_name = "deployer-key1"
# public_key = file("~/.ssh/id_rsa.pub")
# }
resource "aws_key_pair" "deployer1" {
key_name =var.key_name
public_key = file("~/.ssh/id_rsa.pub")
}

Step 7: Remote Backend Configuration
Create a backend.tf file to store the Terraform state in a remote backend (S3 bucket in this example):
terraform {
  backend "s3" {
    bucket = "bucketname"
    key    = "kaizenai/terraform.tfstate"
    region = "us-east-1"
    #dynamodb_table = "lock-state"
  }
}
Step 8: Create a Makefile
Create a Makefile to automate Terraform commands such as  apply  and destroy. This will simplify the deployment process for your team:
virginia:
    terraform workspace new virginia || terraform workspace select virginia
    terraform init
    terraform apply -var-file regions/virginia.tfvars --auto-approve

ohio:
    terraform workspace new ohio || terraform workspace select ohio
    terraform init
    terraform apply -var-file regions/ohio.tfvars --auto-approve

california:
    terraform workspace new california || terraform workspace select california
    terraform init
    terraform apply -var-file regions/california.tfvars --auto-approve

oregon:
    terraform workspace new oregon || terraform workspace select oregon
    terraform init
    terraform apply -var-file regions/oregon.tfvars --auto-approve

apply-all: virginia ohio california oregon

virginia-destroy:
    terraform workspace new virginia || terraform workspace select virginia
    terraform init
    terraform destroy -var-file regions/virginia.tfvars --auto-approve

ohio-destroy:
    terraform workspace new ohio || terraform workspace select ohio
    terraform init
    terraform destroy -var-file regions/ohio.tfvars --auto-approve

california-destroy:
    terraform workspace new california || terraform workspace select california
    terraform init
    terraform destroy -var-file regions/california.tfvars --auto-approve

oregon-destroy:
    terraform workspace new oregon || terraform workspace select oregon
    terraform init
    terraform destroy -var-file regions/oregon.tfvars --auto-approve

destroy-all: virginia-destroy ohio-destroy  california-destroy oregon-destroy

Step 9: Bash Script for Application Installation
Create a bash script gitlab.sh to install your application on the EC2 instance. Customize it according to your application's installation process.
#!/bin/bash
sudo apt update
sudo apt install ca-certificates curl openssh-server tzdata perl -y
curl -LO https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh
sudo bash script.deb.sh
sudo apt install gitlab-ce -y

Part 2: Create a Terraform Module and Publish to Terraform Registry
Before publishing prepare and push your code to GitHub
Go to GitHub:
Visit the GitHub website (https://github.com) in your web browser.
Create a New Repository:
Click on the "+" icon in the upper right corner of the page.
Select "New Repository" from the dropdown menu.
Give Your Repository a Name:
In the "Repository Name" field, provide a name for your new repository.
Check "Add a README file":
Enable the "Add a README file" option to create an initial README file for your repository.
Add a .gitignore File:
Scroll down to the "Add .gitignore" section.
In the dropdown menu, select the type of .gitignore file you need. For Terraform, you can search and select "Terraform."
Copy the SSH Clone URL:
After configuring the repository settings, click on the "Code" button (it might say "Code" or "Code ▼" depending on your GitHub version).
Select "SSH" to switch to SSH cloning.
Copy the SSH clone URL provided.
Clone the Repository:
Open your terminal or command prompt.
Use the git clone command to clone the repository using the SSH URL you copied. Replace <SSH_URL> with the actual URL:
git clone <SSH_URL> 
This command will clone the repository to your local machine.
Modify Your Terraform Configuration:
Navigate to the cloned repository directory.
Locate the ec2.tf file.
Add the following line to specify a dependency on an AWS subnet named subnet1 
Commit and Push Changes:
Commit your changes using the git commit command.
Push the changes to the GitHub repository using the git push command.
By following these steps, you will have created a new GitHub repository, cloned it to your local machine, made modifications to your Terraform configuration in the ec2.tf file, and pushed the changes back to the repository. 

Creating a Terraform module and publishing it to the Terraform Registry allows others to easily reuse your infrastructure code. 
Step 1: Ensure Well-Structured Code
Before creating a module, ensure your existing Terraform code is well-structured, modular, and follows best practices.
Step 2: Visit the Terraform Registry
Visit the Terraform Registry.
Step 3: Sign In
Sign in to your GitHub account. This grants the Terraform Registry access to your GitHub repositories.
Step 4: Publish a Module
Click on "Publish" and select "Module" from the dropdown.
Step 5: Select GitHub Repository
Choose the GitHub repository for the module you want to publish from the list of your repositories.
Step 6: Agree to Terms
Check the box next to "I agree to the Terms of Use."
Step 7: Put  this code in your READ.me file
                module "vp" {
   source = "kaizenacademy/vp/module"
   version = "0.0.1"
   region = "us-east-1"
   vpc_cidr = "10.0.0.0/16"
   subnet_cidr1 = "10.0.101.0/24"
   subnet_cidr2 = "10.0.2.0/24"
   subnet_cidr3 = "10.0.3.0/24"
   az1 = "us-east-1a"
   az2 = "us-east-1b"
   az3 = "us-east-1c"
   ip_on_launch = true
   instance_type = "t2.micro"
}

 Publish Module
Click the "Publish Module" button.
Your Terraform module is now published on the Terraform Registry and can be easily discovered and used by others. Share the module URL with your team or the community to encourage adoption in their Terraform configurations.

Team member
Hours                                                                                                                       
Aidai 
13
Aidana
14
Darya
12
Ulan
13


 -->
