variable "vpc_cidr" {
  type = string

}
variable "subnet" {
  type = list(string)
}

variable "private_subnets" {
  description = "Subnets CIDR"
  type        = list(string)
}

