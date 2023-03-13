provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "iphone" {
  name     = "iphone"
  location = "australiaeast"
}
resource "azurerm_virtual_network" "icicinetwork" {
  name                = "icicinetwork"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.iphone.location
  resource_group_name = azurerm_resource_group.iphone.name
}
resource "azurerm_subnet" "iphone-sb" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.iphone.name
  virtual_network_name = azurerm_virtual_network.icicinetwork.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_public_ip" "publicip" {
  name                = "publicip"
  resource_group_name = azurerm_resource_group.iphone.name
  location            = azurerm_resource_group.iphone.location
  allocation_method   = "Dynamic"
  tags = {
    environment = "Production"
  }
}
resource "azurerm_network_interface" "NIC" {
  name                = "iphone-nic"
  location            = azurerm_resource_group.iphone.location
  resource_group_name = azurerm_resource_group.iphone.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.iphone-sb.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}
resource "azurerm_network_security_group" "nsg" {
  name                = "ssh_nsg"
  location            = azurerm_resource_group.iphone.location
  resource_group_name = azurerm_resource_group.iphone.name

  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow_80_sg"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow_8080_sg"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.NIC.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "iphone-machine"
  resource_group_name = azurerm_resource_group.iphone.name
  location            = azurerm_resource_group.iphone.location
  size                = "Standard_D2_v2"
  network_interface_ids = [
    azurerm_network_interface.NIC.id,
  ]
  admin_username      = "adminuser"
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  provisioner "remote-exec" {
        connection {
        host = self.public_ip_address
        #host = "${azurerm_public_ip.publicip.ip_address}"
        #user = "adminuser"
        user = self.admin_username
        type = "ssh"
        private_key = "${file("~/.ssh/id_rsa")}"
        timeout = "4m"
        agent = false
    }

        inline = [
          "sudo apt-get update",
          "sudo apt install openjdk-11-jdk -y && wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add - && echo deb https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list && sudo apt-get update && sudo apt-get install jenkins && sudo systemctl start jenkins && sudo systemctl status jenkins",
          "sudo apt-get update && sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg -y && curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor |sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null && echo 'deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main' |sudo tee /etc/apt/sources.list.d/azure-cli.list && sudo apt-get update && sudo apt-get install azure-cli -y && az --version",
          "sudo apt-get install docker.io -y",
          "sudo systemctl start docker && sudo systemctl status docker",
          "sudo usermod -a -G docker jenkins"
        ]
        }
}
