resource "azurerm_resource_group" "RG" {
  name     = "RG_Group"
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "Testnetwork"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.RG.name
  tags                = {}
}

resource "azurerm_subnet" "internal" {
  name                 = "Testinternal"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "pub001" {
  name                    = "Test-Pub"
  location                = var.location
  resource_group_name     = azurerm_resource_group.RG.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
  tags                    = {}
}

resource "azurerm_network_interface" "test-network" {
  name                = "LAN-Test"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pub001.id
  }

  tags = {}
}

resource "azurerm_network_security_group" "test_NSG" {
  name                = "TestSecurityGroup1"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {}
}

resource "azurerm_network_interface_security_group_association" "NSG_Association" {
  network_interface_id      = azurerm_network_interface.test-network.id
  network_security_group_id = azurerm_network_security_group.test_NSG.id
}

resource "azurerm_windows_virtual_machine" "TerraformVM" {
  name                = "TestVM"
  resource_group_name = azurerm_resource_group.RG.name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.test-network.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  tags = {
    Application      = "MSoffice"
    Audit_Scope      = "No"
    Environment      = "Test"
    Owner            = "mahesh"
    Horizontal       = "A"
    Vertical         = "B"
    Tier             = "Data"
    Technical_Owner  = "Leo"
  }
}
