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

variable "subnets" {
  type = map(string)
  default = {
    "eu-central-1a" = "10.1.8.0/21"
    "eu-central-1b" = "10.1.16.0/21"
  }
}

variable "egress_rules" {
  type = list(object({
    port        = number,
    protocol    = string,
    cidr_blocks = list(string),
    description = string
  }))
  default = [
    { port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"], description = "allow_outbound" }
  ]
}

variable "ingress_rules" {
  type = list(object({
    port        = number,
    protocol    = string,
    cidr_blocks = list(string),
    description = string,
    self        = bool
  }))
  default = [
    { port = 0, protocol = "-1", cidr_blocks = ["89.25.216.26/32"], description = "allow_home", self = false },
    { port = 0, protocol = "-1", cidr_blocks = ["5.58.65.60/32"], description = "allow_serhii", self = false },
    { port = 3000, protocol = "TCP", cidr_blocks = ["0.0.0.0/0"], description = "allow_3000_port", self = false },
    { port = 443, protocol = "TCP", cidr_blocks = ["0.0.0.0/0"], description = "allow_https", self = false },
    { port = 80, protocol = "TCP", cidr_blocks = ["0.0.0.0/0"], description = "allow_http", self = false },
    { port = 0, protocol = "-1", cidr_blocks = [], description = "allow_self", self = true }
  ]
}

variable "aws_db_instance_pass" {
  type = string
}