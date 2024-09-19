variable "project-name" {
  type    = string
  default = "Opsfusionlabs"
}
variable "prj_sn" {
  type = string
  default = "ofl"
}


variable "ofl-cider-range" {
  type    = string
  default = "10.17.0.0/24"
}


variable "ofl_az" {
  type = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}


variable "ofl-public-subnet-cidr" {
  type = list(string)
  default = ["10.17.0.0/26", "10.17.0.64/26" ] 
}

variable "ofl-private-subnet-cidr" {
  type = list(string)
  default = ["10.17.0.128/26", "10.17.0.192/26" ] 
}

variable "ofl-open-network" {
  type = string
  default = "0.0.0.0/0"
}