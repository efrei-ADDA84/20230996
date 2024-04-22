data "azurerm_resource_group" "rg_imane" {
  name = var.resource_group_name
}


data "azurerm_virtual_network" "vnet_imane" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.rg_imane.name
}

data "azurerm_subnet" "subnet_imane" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.rg_imane.name
  virtual_network_name = var.vnet_name
}
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "${var.username}-${var.identifiant_efrei}-public-ip"
  location            = data.azurerm_resource_group.rg_imane.location
  resource_group_name = data.azurerm_resource_group.rg_imane.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "interface_imane" {
  name                = "nic-${var.identifiant_efrei}"
  location            = data.azurerm_resource_group.rg_imane.location
  resource_group_name = data.azurerm_resource_group.rg_imane.name

  ip_configuration {
    name                          = var.subnet_name
    subnet_id                     = data.azurerm_subnet.subnet_imane.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}


# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm_imane" {
  name                  = "${var.username}-${var.identifiant_efrei}"
  location              = data.azurerm_resource_group.rg_imane.location
  resource_group_name   = data.azurerm_resource_group.rg_imane.name
  network_interface_ids = [azurerm_network_interface.interface_imane.id]
  size                  = "Standard_D2s_v3"

  os_disk {
    name                 = "disk-${var.identifiant_efrei}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name  = var.identifiant_efrei
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = file("${path.module}/id_rsa.pub")
  }


  disable_password_authentication = true

  custom_data = filebase64("${path.module}/installer_docker.sh")
}



