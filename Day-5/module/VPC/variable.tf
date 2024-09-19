variable "ofl-cidr-range" {
  type = string
}
variable "project-name" {
  type = string
}

variable "ofl-public-subnet-cidr" {
  type = list(string)
}
variable "ofl_az" {
  type = list(string)
}

variable "ofl-open-network" {
  type = string
}