variable "region" {
  description = "region"
  type        = string
  default     = "ap-southeast-1"
}
variable "availability_zone" {
  description = "availability_zone"
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

variable "ec2_pubKey_src" {
  description = "ec2 public key src"
  default     = "/home/tanawin/.aws/mykey2.pub"
}

//////aws config

variable "aws_profile" {
  description = "aws profile name(acces key NAME)"
  type        = string
  default     = "god"
}

///////s3 config
variable "s3_force_destroy" {
  description = "title of wordpress"
  type        = bool
  default     = false
}


#STEP instance type

variable "inst_type" {
  description = "instance type "
  type        = string
  default     = "t2.micro"
}

#STEP wp config

variable "wp_title" {
  description = "title of wordpress"
  type        = string
  default     = "test"
}



variable "wp_email" {
  description = "email of wordpress"
  type        = string
  default     = "example@gmail.com"
}

#WordPress Security Key Generator
variable "wp_AUTH_KEY" {
  description = "wp security"
  type        = string
  default     = "put your unique phrase here"
}

variable "wp_SECURE_AUTH_KEY" {
  description = "wp security"
  type        = string
  default     = "put your unique phrase here"
}

variable "wp_LOGGED_IN_KEY" {
  description = "wp security"
  type        = string
  default     = "put your unique phrase here"
}

variable "wp_NONCE_KEY" {
  description = "wp security"
  type        = string
  default     = "put your unique phrase here"
}

variable "wp_AUTH_SALT" {
  description = "wp security"
  type        = string
  default     = "put your unique phrase here"
}

variable "wp_SECURE_AUTH_SALT" {
  description = "wp security"
  type        = string
  default     = "put your unique phrase here"
}

variable "wp_LOGGED_IN_SALT" {
  description = "wp security"
  type        = string
  default     = "put your unique phrase here"
}

variable "wp_NONCE_SALT" {
  description = "wp security"
  type        = string
  default     = "put your unique phrase here"
}