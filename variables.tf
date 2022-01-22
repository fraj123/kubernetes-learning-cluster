variable "vpc_id" {
  type = string
}

variable "subnet_id_a" {
  type = string
}

variable "subnet_id_b" {
  type = string
}

variable "subnet_id_c" {
  type = string
}

variable "ssh_user" {
  type = string
}

variable "key_name" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "name_instance" {
  type = string
}

variable "ssh_access_ip" {
  type = list(string)
}

variable "vpc_access_cidr" {
  type = list(string)
}
