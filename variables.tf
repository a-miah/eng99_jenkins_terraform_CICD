# In this file we will create variables to use in main.tf
# variable.tf

# Let's create a var for name of our instance

variable "name" {
  default = "eng99_attaik_app_instance"
}

#  Let's create a var for our ami id
variable "app_ami_id" {
  default = "ami-07d8796a2b0f8d29c"
}

variable "vpc_id" {
  default = "vpc-0773d9a09ce3aa40e"
}

variable "aws_public_subnet" {
  default = "eng99_attaik_terraform_public_sn"
}

variable "aws_key_name" {
  default = "eng99"
}
