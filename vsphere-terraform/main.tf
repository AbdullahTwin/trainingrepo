provider "vsphere" {
  user           = "your_username"
  password       = "your_password"
  vsphere_server = "vcenter_server_ip"

  # Adjust these according to your vCenter configuration
  allow_unverified_ssl = true
}

data "vsphere_compute_cluster" "cluster" {
  name          = "cluster-01"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datacenter" "dc" {
  name = "your_datacenter_name"
}

# This is the datastore the VM is using
data "vsphere_datastore" "datastore" {
  name          = "your_datastore_name"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "your_network_name"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "your_vm_name"
  resource_pool_id = "your_resource_pool_id"
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = "your_vm_folder_path"
  num_cpus         = 4
  memory           = 16384 # in MB (16GB)
  guest_id = "rhel8_64Guest" # Red Hat Enterprise Linux 8 64-bit guest ID

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "disk0"
    size             = 500 # in GB
    eagerly_scrub    = true
    thin_provisioned = true
  }

  # CD/DVD drives
  cdrom {
    datastore_id = data.vsphere_datastore.datastore.id
    path         = "path/to/env-ovf-xml.iso" # Path to RHEL 8 ISO file
  }

  cdrom {
    datastore_id = data.vsphere_datastore.datastore.id
    path         = "/path/to/RTE-vX.X.X.X.iso" # Path to another ISO file
  }
}
