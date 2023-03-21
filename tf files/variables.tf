variable "environment" {
  default = "phonebook"
}
variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "az1" {
  default = "us-east-1a"
}

variable "az2" {
  default = "us-east-1b"
}

variable "subnet1a_cidr" {
  default = "10.0.1.0/24"
}

variable "subnet1b_cidr" {
  default = "10.0.2.0/24"
}

variable "instance-type" {
  default = "t2.micro"
}

variable "key-name" {

}

variable "git-token" {

}

variable "git-name" {

}


