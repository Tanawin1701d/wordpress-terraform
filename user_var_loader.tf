variable "region" {
  description = "region"
  type        = string
  default     = "ap-southeast-1"
}
variable "availability_zone" {
  description = "ami"
  type        = string
  default     = "ap-southeast-1a"
}
variable "ami" {
  description = "ami"
  type        = string
  default     = "ami-0d058fe428540cd89"
}
variable "bucket_name" {
  description = "bucket_name"
  type        = string
  default     = "tanawin1701sds"
}
variable "database_name" {
  description = "wordpress"
  type        = string
  default     = "wordpress"
}
variable "database_user" {
  description = "database_user"
  type        = string
  default     = "username"
}
variable "database_pass" {
  description = "database_pass"
  type        = string
  default     = "password"
}
variable "admin_user" {
  description = "admin_user"
  type        = string
  default     = "admin"
}
variable "admin_pass" {
  description = "admin_pass"
  type        = string
  default     = "admin"
}