variable "aws_region" {
  default = "ap-south-1"
}

variable "image_uri" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "ecs_security_group_id" {
  type = string
}

variable "admin_jwt_secret" {
  type = string
}

variable "jwt_secret" {
  type = string
}

variable "app_keys" {
  type = string
}

variable "api_token_salt" {
  type = string
}

variable "transfer_token_salt" {
  type = string
}

variable "encryption_key" {
  type = string
}
