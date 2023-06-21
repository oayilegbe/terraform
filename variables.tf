#The last file we will create is the variables.tf file. 
#Using a variable file makes it easier to reuse Terraform files across multiple accounts. 
#We don’t want to hardcode values that may change or that are particular to just you.

#Your values will be different but here is what it should look like.

# variable "subnet_id" {
#     description = "The VPC subnet the instance(s) will be created in"
#     default = "subnet-0d4d278845246bb3b" #look in AWS console for your default subnet
# }

# variable "vpc_id" {
#     type = string
#     default = "vpc-01814c64052aee6d4" #look in AWS console for your default VPC
# }

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "key_name" {
    type = string
    default = "class30key" #look in AWS console for your key name
}

# variable "path" {
#     type = string
#     default = "./install_jenkins.sh"
# }