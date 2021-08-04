terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.29.0"
    }
  }

  required_version = ">= 0.15.0"
}

provider "azurerm" {
  features {}
}

# Create resource group
resource "azurerm_resource_group" "vm_group" {
  name     = "VirtualMachineGroup"
  location = "UK South"
}

# Create virtual network
resource "azurerm_virtual_network" "vm_network" {
  name                = "VirtualMachineNetwork"
  address_space       = ["10.0.0.0/22"]
  resource_group_name = azurerm_resource_group.vm_group.name
  location            = "UK South"
}

# Create network subnet
resource "azurerm_subnet" "vm_subnet" {
  name                 = "VirtualMachineSubnet"
  resource_group_name  = azurerm_resource_group.vm_group.name
  virtual_network_name = azurerm_virtual_network.vm_network.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Create network adapter
resource "azurerm_network_interface" "vm_network_interface" {
  name                = "VirtualMachineNetworkInterface"
  location            = "UK South"
  resource_group_name = azurerm_resource_group.vm_group.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "virtual_machine" {
  name                  = "VM"
  resource_group_name   = azurerm_resource_group.vm_group.name
  location              = "UK South"
  size                  = "Standard_B1s"
  admin_username        = "serkan"
  admin_password        = "sdfhq48SDFdf224sf"
  license_type          = "Windows_Server"
  network_interface_ids = [azurerm_network_interface.vm_network_interface.id]

  os_disk {
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "32"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter-smalldisk"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = null
  }

  tags = {
    environment = "Production"
  }

}
