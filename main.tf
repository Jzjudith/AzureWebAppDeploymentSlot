resource "azurerm_resource_group" "example" {
  name     = "wep-app-deplymt-rg"
  location = "East US2"
}



resource "azurerm_service_plan" "example" {
  name                = "iveniincplan"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  os_type             = "Windows"
  sku_name            = "P1v2"
}

resource "azurerm_windows_web_app" "example" {
  name                = "iveniinc"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  site_config {}
}

resource "azurerm_windows_web_app_slot" "prod" {
  name           = "prod"
  app_service_id = azurerm_windows_web_app.example.id

  site_config {}
}

resource "azurerm_windows_web_app_slot" "slot" {
  name           = "slot"
  app_service_id = azurerm_windows_web_app.example.id

  site_config {}

}

resource "azurerm_dns_zone" "example" {
  name                = "iveniinc.com"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_dns_a_record" "example" {
  name                = "prod"
  zone_name           = azurerm_dns_zone.example.name
  resource_group_name = azurerm_resource_group.example.name
  ttl                 = 300
  records             = ["127.0.0.1"]
}
resource "azurerm_dns_cname_record" "example" {
  name                = "slot"
  zone_name           = azurerm_dns_zone.example.name
  resource_group_name = azurerm_resource_group.example.name
  ttl                 = 300
  record              = "azurewebsites.net"
}

# resource "azurerm_dns_txt_record" "example" {
#   name                = "mail"
#   zone_name           = azurerm_dns_zone.example.name
#   resource_group_name = azurerm_resource_group.example.name
#   ttl                 = 300
#   record {
#     value = "azurewebsites.net"
#   }
#   }


 resource "azurerm_application_insights" "example" {
  name                = "tf-test-appinsights"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
}

output "instrumentation_key" {
  value = azurerm_application_insights.example.instrumentation_key
  sensitive = true
}

output "app_id" {
  value = azurerm_application_insights.example.app_id
  sensitive = true
}

# resource "azurerm_app_service_source_control" "example" {
#   app_id   = azurerm_windows_web_app.example.id
#   repo_url = ""
#   branch   = "example"
#   use_manual_integration = true
#   use_mercurial = false
#   rollback_enabled = true
#   }

#  resource "azurerm_source_control_token" "example" {
#   type  = "GitHub"
#   token = ""
# }

# resource "azurerm_web_app_active_slot" "main" {
#   slot_id = azurerm_linux_web_app_slot.main.id
  
# }