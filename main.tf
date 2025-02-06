module "vpc_infra1" {
  source = "./modules/core"

#   account_id = var.account_id
#   ecr_account_id = var.ecr_account_id
  region = var.region

  cidr_prefix = var.cidr_prefix
  subnet1_suffix = var.subnet1_suffix
  subnet2_suffix = var.subnet2_suffix
  environment = var.environment

#   peer_ip_prefix = var.peer_ip_prefix
#   peer_gateway_id = var.peer_gateway_id

  
#   unique = var.unique

#   dnsroot = var.dnsroot
#   public_key = var.public_key 
#   influx_token = var.influx_token
#   timescale_instance = var.timescale_instance
#   mongo_instance = var.mongo_instance
#   elb_account_id = var.elb_account_id

#   ecs_image_tag = var.ecs_image_tag
#   stamp-backoffice-rs = var.stamp-backoffice-rs
#   stamp-mdcap = var.stamp-mdcap
#   stamp-price-service = var.stamp-price-service
#   stamp-trade-portal_envoy = var.stamp-trade-portal_envoy
#   stamp-trade-portal_statics = var.stamp-trade-portal_statics
#   stamp-trade-api = var.stamp-trade-api
#   am-analytics = var.am-analytics
#   flowlogs = var.flowlogs
#   coin_ws_endpoint = var.coin_ws_endpoint
#   coin_rest_endpoint = var.coin_rest_endpoint
#   coin_auth_key = var.coin_auth_key
#
#   core_region = var.core_region
#   ecr_region = var.ecr_region
#   core_vpc_id = var.core_vpc_id
# 
}

