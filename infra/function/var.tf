variable "layer_arn_list" {
  type    = list(string)
  default = []
}

variable "function_name" {
  type = string
}

variable "iam_role_arn" {
  type = string
}