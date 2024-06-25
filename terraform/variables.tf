variable "tags" {
  type = object({
    Name    = string
    Managed = string
    Owner   = string
  })
}

variable "vpc_cidr_block" {
  type = string
}

variable "root_disk_size" {
  type    = number
  default = 8
}

variable "instance_type" {
  type = string
}

variable "aws_db_instance_pass" {
  type = string
}