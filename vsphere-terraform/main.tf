###########################################
# Define Variables 
###########################################
variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}

################################################
# Provider section
################################################
provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

#################################################
# Capturing the data from vsphere
#################################################
data "vsphere_datacenter" "dc" {
  name = "datacenter_name"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore_name"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "resource_pool_name"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "network_name"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

###################################################
# Resources
###################################################
resource "vsphere_virtual_machine" "vm" {
  name             = "vm_name"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 4
  memory   = 16384
  guest_id = "rhel8_64Guest"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "disk0"
    size  = 500
  }

  cdrom {
    datastore_id = data.vsphere_datastore.iso_datastore.id
    path         = "/Volume/Storage/ISO/RTE.iso"
  }

  cdrom {
    datastore_id = data.vsphere_datastore.iso_datastore.id
    path         = "/Volume/Storage/ISO/OVF-ENV.iso"
  }
}