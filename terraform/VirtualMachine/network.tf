resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${local.common_labels.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space

  tags = local.common_labels
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = "${each.value.subnet_name}-${local.common_labels.environment}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefix

}

resource "azurerm_network_security_group" "nsg1" {
  name                = "security-group-${local.common_labels.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "inbound_tcp_8080"
    priority                   = 100
    description                = "Allow traffic to instance via port 8080"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "inbound_ssh"
    priority                   = 101
    description                = "Allow SSH to instance"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.common_labels
}

resource "azurerm_route_table" "route_table" {

  name                          = "route-table-${local.common_labels.environment}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  disable_bgp_route_propagation = false

  dynamic "route" {
    for_each = var.subnets
    content {
      name           = "${route.value.subnet_name}"
      address_prefix = route.value.address_prefix[0]
      next_hop_type  = "VnetLocal"
    }
  }

  tags = local.common_labels
}

resource "azurerm_subnet_route_table_association" "subnet_route_table_association" {
  count = length(var.subnets)

  subnet_id      = azurerm_subnet.subnets[count.index].id
  route_table_id = azurerm_route_table.route_table.id
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association1" {
  count = length(var.subnets)
  # for_each = var.subnets

  subnet_id                 = azurerm_subnet.subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}

