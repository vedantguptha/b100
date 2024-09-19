variable "ofl-ami" {
  description = "Ami ID"
  type        = string
  default     = "ami-022ce6f32988af5fa"
}

variable "ofl-instance_type" {
  description = "value"
  type        = string
  default     = "t2.micro"
}



variable "ofl-cidr_block" {
  type        = string
  default     = "10.17.0.0/24"
}