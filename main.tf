
locals {
  costcenter_tag = coalesce(var.costcenter, var.projectname)

}


resource "random_string" "this" {
  length  = 5
  lower   = true
  number  = true
  special = false
}

resource "random_password" "this" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.stackname}-compute"
  location = "westeurope"

  tags = {
    owner      = var.owner
    costcenter = local.costcenter_tag ? local.costcenter_tag : "undefined"
  }
}

resource "azurerm_network_interface" "this" {
  name                = "poc${random_string.this.result}-internal-nic"
  resource_group_name = data.azurerm_virtual_network.poc.resource_group_name
  location            = data.azurerm_virtual_network.poc.location

  ip_configuration {
    name                          = "intenal"
    subnet_id                     = data.azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "this" {

  name                = "poc${random_string.this.result}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = "Standard_B4ms"

  admin_username = "nebulauser"
  admin_password = random_password.this.result

  network_interface_ids = [
    azurerm_network_interface.this.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "20h2-pro"
    version   = "latest"
  }

  lifecycle {
    ignore_changes = [
      admin_username,
      admin_password,
    ]
  }

}


resource "azurerm_key_vault_secret" "this" {
  name         = "${azurerm_windows_virtual_machine.this.name}-admin-password"
  key_vault_id = data.azurerm_key_vault.common.id
  value        = random_password.this.result
}
