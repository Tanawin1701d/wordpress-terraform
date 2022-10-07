#STEP sec0
variable "sec0_cidr_block" {
  description = "cidr block for sec0"
  type        = string
  default     = "10.0.0.0/16"
}


variable "sec0_subnet_cidr" {
  description = "subnet for sec0"
  type        = string
  default     = "10.0.1.0/24"
}

variable "sec0_net_inf_addr" {
  description = "ipv4 addr for web servers"
  type        = string
  default     = "10.0.1.48"
}
#STEP sec1
variable "sec1_subnet_cidr" {
  description = "subnet for sec1"
  type        = string
  default     = "10.0.2.0/24"
}

variable "sec1_priv_subnet_cidr" {
  description = "subnet for sec1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "sec1_net_inf_addr" {
  description = "ipv4 addr for web servers"
  type        = string
  default     = "10.0.3.48"
}

#STEP sec2
variable "sec2_subnet_cidr" {
  description = "subnet for sec0"
  type        = string
  default     = "10.0.4.0/24"
}

variable "sec2_net_inf_addr" {
  description = "ipv4 addr for ws"
  type        = string
  default     = "10.0.4.48"
}
variable "sec2_net_inf_addr2" {
  description = "ipv4 addr for db"
  type        = string
  default     = "10.0.4.49"
}
#STEP instance db
variable "inst_db_port" {
  description = "port for database"
  type        = string
  default     = "3306"
}