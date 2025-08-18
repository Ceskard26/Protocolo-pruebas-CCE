variable "region" {
  description = "Región de IBM Cloud para el despliegue"
  type        = string
  default     = "us-south"
}

variable "zone_number" {
  description = "Número de zona dentro de la región"
  type        = string
  default     = "1"
}

variable "ssh_keyname" {
  description = "Nombre de la SSH key en IBM Cloud"
  type        = string
}

variable "vpc_name" {
  description = "Nombre de la VPC existente"
  type        = string
}

variable "subnet_name" {
  description = "Nombre de la subnet existente"
  type        = string
}

variable "image_name" {
  description = "Nombre de la imagen para las VSIs"
  type        = string
  default     = "ibm-centos-stream-9-amd64-11"
}

variable "vsi_profile" {
  description = "Perfil de la VSI (CPU y memoria)"
  type        = string
  default     = "cx2-4x8"
}

variable "vsi_count" {
  description = "Número total de VSIs a crear"
  type        = number
  default     = 100
}

variable "resource_group" {
  description = "Nombre del resource group"
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  default     = "development"
}