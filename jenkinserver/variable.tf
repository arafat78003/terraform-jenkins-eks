variable "vpc_cidr" {
  type = string

}
variable "subnet" {
  type = list(string)
}

variable "availablity" {
  type = list(string)

}
variable "intance-type" {
  type = string

}