
resource "azurerm_policy_definition" "allowedzones" {
  name         = "allowed-zones"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed locations"

  policy_rule = <<POLICY_RULE
{
      "if": {
        "allOf": [
          {
            "field": "location",
            "notIn": "[parameters('allowedLocations')]"
          },
          {
            "field": "location",
            "notEquals": "global"
          },
          {
            "field": "type",
            "notEquals": "Microsoft.AzureActiveDirectory/b2cDirectories"
          }
        ]
      },
      "then": {
        "effect": "deny"
      }
    }
POLICY_RULE


  parameters = <<PARAMETERS
    {
    "allowedLocations": {
      "type": "Array",
      "metadata": {
        "description": "The list of allowed locations for resources.",
        "displayName": "Allowed locations",
        "strongType": "location"
      }
    }
  }
PARAMETERS

}

resource "azurerm_policy_assignment" "allowedzones" {
  name                 = "allowed-zone-assignment"
  scope                = azurerm_resource_group.vm_group.id
  policy_definition_id = azurerm_policy_definition.allowedzones.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Allowed Locations Policy"
  # depends_on = [
  #   azurerm_resource_group.vm_group
  # ]

  metadata = <<METADATA
    {
    "category": "General"
    }
METADATA

  parameters = <<PARAMETERS
{
  "allowedLocations": {
    "value": [ "UK South" ]
  }
}
PARAMETERS

}