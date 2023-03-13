########################
# Deployment Information
########################
# name: clevertap-infrastructure
# version: 0.5.1
# description: Cleavertap deployment for Azure
### Log
# 0.1.0 [Feature] base deployment
# 0.2.0 [Feature] add null resource to configure vnet rules associated to preprod subscription -- subscription adding
# 0.3.0 [Feature] add Azure resources to deployment on Vnet -- Virutal Networking & list of subnets confiugre for Clevertap
# 0.3.1 [Feature] add AAD SPN Confiugration detials add   --   Configure Role / Application on AAD ( Azure Active Directory)
# 0.3.2 [Fix] use naming conventios module for azure resources  -- Configure naming convention module as per Enviroment, customer, Product, BU Team, Infra-Version etc.
# 0.3.3 [Feature] add conditional to enable or disable the azure resources creation  -- Jenkins VM -- master-slave setup VM Configure
# 0.3.4 [Feature] Create service principal for Clevertap storage account
# 0.4.0 [Feature] Create vault policy and tojen creation automation
# 0.5.0 [Feature] Create AKS & Application Gateway & Azure Database flaxiable sever with clevertapDB with conncection string for Appsetting.json etc..& Vnet-Rule configure
# 0.5.1 [Fix] Enable access to able db from injectors
