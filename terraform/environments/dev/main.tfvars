# Common
resource_group_name = "rg-demo"
location            = "uksouth"

# Database
server_name = "pg-flexi-01"

# Fronend container service and app
app_db_name     = "casesdb"
name            = "cases"
container_image = "cases-app:latest"