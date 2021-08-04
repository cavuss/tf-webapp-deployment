# resource "azurerm_policy_assignment" "allowedzones" {
#     name = "allowed-locations"
#     scope = var.cust_scope
#     policy_definition_id = "/subscriptions/9c75dde5-f6c1-4b73-9be2-c2645dc4e4f2/providers/Microsoft.Authorization/policyAssignments/cfca0d61cb324bb9b60c12a1"
#     description = "Restrict the locations your organization can specify when deploying resources"
#     display_name = "Allowed locations"
# }
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
  scope                = var.sub_scope
  policy_definition_id = azurerm_policy_definition.allowedzones.id
  description          = "Policy Assignment created via an Acceptance Test"
  display_name         = "Allowed Locations Policy"

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