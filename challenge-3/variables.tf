variable "region" {
    description = "The region of our aws resources"
    default = "eu-west-2"
}

variable "ami" {
    description = "The AMI id to be used on the EC2 resource"
    default = "ami-06178cf087598769c"
}

variable "instance_type" {
    description = "The instance type of the EC2 resource"
    default = "m5.large"
}

variable "key_name" {
    default = "citadel"
}