resource "azurerm_policy_assignment" "allowedvms" {
  name                 = "allowed-vms-assignment"
  scope                = azurerm_resource_group.vm_group.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3"
  description          = "The list of size SKUs that can be specified for virtual machines."
  display_name         = "Allowed Size SKUs"
  # depends_on = [
  #   azurerm_resource_group.vm_group
  # ]

  metadata = <<METADATA
    {
    "category": "Compute"
    }
METADATA

  parameters = <<PARAMETERS
{
  "listOfAllowedSKUs": {
    "value": [ "Standard_B1s", "Standard_B2s", "Standard_B1ls", "Standard_B2ms" ]
  }
}
PARAMETERS

}