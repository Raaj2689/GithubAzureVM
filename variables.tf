variable "admin_username" {
  type        = string
  description = "Admin username for the VM"
}

variable "admin_password" {
  type        = string
  description = "Admin password for the VM"
  sensitive   = true
}

variable "location" {
  type        = string
  default     = "Central US"
  description = "Azure region"
}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}
