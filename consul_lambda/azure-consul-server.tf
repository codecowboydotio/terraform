resource "azurerm_public_ip" "consul_public_ip" {
  name                = "${var.name-prefix}-${var.project}-consul-PublicIp1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "consul_nsg" {
  name 			= "${var.name-prefix}-${var.project}-consul-nsg"
  location		= azurerm_resource_group.rg.location
  resource_group_name	= azurerm_resource_group.rg.name

    security_rule {
    name                       = "Allow all"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = [ azurerm_network_security_group.consul_nsg, azurerm_resource_group.rg ]
}

# Create network interface
resource "azurerm_network_interface" "consul_nic" {
  name                = "${var.name-prefix}-${var.project}-consul-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "consul_nic_configuration"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.consul_public_ip.id
  }

  depends_on = [ azurerm_network_security_group.consul_nsg, azurerm_resource_group.rg ]
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "consul-nsg-assoc" {
  network_interface_id      = azurerm_network_interface.consul_nic.id
  network_security_group_id = azurerm_network_security_group.consul_nsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "consul_random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

# Data template Bash bootstrapping file
data "template_file" "consul_vm_cloud_init" {
  template = file("azure-consul-server.sh.tpl")
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "consul_storage_account" {
  name                     = "diag${random_id.consul_random_id.hex}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "consul_vm" {
  name                  = "${var.name-prefix}-${var.project}-consul-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.consul_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "consulOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "consulvm"
  admin_username                  = "azureuser"
  admin_password		  = "Password123"
  custom_data = base64encode(data.template_file.consul_vm_cloud_init.rendered)
  disable_password_authentication = false

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.consul_storage_account.primary_blob_endpoint
  }

  depends_on = [ azurerm_network_security_group.consul_nsg, azurerm_resource_group.rg ]

}

output "azure_consul_public_ip_address" {
  value = azurerm_linux_virtual_machine.consul_vm.public_ip_address
}
output "azure_consul_private_ip_address" {
  value = azurerm_linux_virtual_machine.consul_vm.private_ip_address
}
