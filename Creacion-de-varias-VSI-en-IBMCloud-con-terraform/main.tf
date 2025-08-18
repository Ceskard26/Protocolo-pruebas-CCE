terraform {
  required_version = ">= 1.0"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~> 1.68.0"
    }
  }
}

##############################################################################
# Provider para Dallas únicamente
##############################################################################

provider "ibm" {
  region      = var.region
  max_retries = 20
}

##############################################################################
# Data sources
##############################################################################

data "ibm_resource_group" "group" {
  name = var.resource_group
}

data "ibm_is_ssh_key" "ssh_key" {
  name = var.ssh_keyname
}

data "ibm_is_vpc" "vpc" {
  name = var.vpc_name
}

data "ibm_is_subnet" "subnet" {
  name = var.subnet_name
}

data "ibm_is_image" "centos" {
  name = var.image_name
}

##############################################################################
# VSI Deployment en Dallas
##############################################################################

resource "ibm_is_instance" "cce_vsi" {
  count   = var.vsi_count
  name    = "vsi-cce-${count.index + 1}"
  image   = data.ibm_is_image.centos.id
  profile = var.vsi_profile

  primary_network_interface {
    subnet = data.ibm_is_subnet.subnet.id
  }

  vpc            = data.ibm_is_vpc.vpc.id
  zone           = "${var.region}-${var.zone_number}"
  keys           = [data.ibm_is_ssh_key.ssh_key.id]
  resource_group = data.ibm_resource_group.group.id

  tags = [
    "environment:${var.environment}",
    "project:cce",
    "region:${var.region}"
  ]
}

##############################################################################
# Outputs
##############################################################################

output "vsi_ids" {
  description = "IDs de las VSIs creadas"
  value       = ibm_is_instance.cce_vsi[*].id
}

output "vsi_names" {
  description = "Nombres de las VSIs creadas"
  value       = ibm_is_instance.cce_vsi[*].name
}

output "vsi_private_ips" {
  description = "IPs privadas de las VSIs"
  value       = ibm_is_instance.cce_vsi[*].primary_network_interface.0.primary_ipv4_address
}