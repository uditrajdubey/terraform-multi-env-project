
variable "custom_env" {
  type        = string
  description = "Env in which Aws resources are created "
}

variable "ec2_ami_id" {
  type        = string
  description = "Ami ID of the instance"
}

variable "ec2_count" {
  type        = number
  description = "N.o of ec2 instances"
}
variable "ec2_type" {
  type        = string
  description = "type of ec2 instances"
}
