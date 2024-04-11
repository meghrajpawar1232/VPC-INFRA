# Will eventually need to be commented out.  Could be used for reference
# for creating future VPCs, which is why it is left here.
resource "aws_vpc" "main" {
  cidr_block = "${var.cidr_prefix}.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "DEMO${var.environment}"
  }
}

# resource "aws_route53_zone_association" "zone" {
#   vpc_id = aws_vpc.main.id
#   zone_id = data.aws_route53_zone.zone.zone_id
# }

# resource "aws_vpn_gateway" "vpn_gw" {
#   vpc_id = aws_vpc.main.id
#   tags = {
#     Name = "DEMO${var.environment}"
#   }
# }

# resource "aws_flow_log" "main1" {
#   log_destination = "${aws_s3_bucket.flow_log1.arn}/awsflowlogs/"
#   log_destination_type = "s3"
#   traffic_type = "ALL"
#   vpc_id = aws_vpc.main.id
#   log_format = "$${version} $${account-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status} $${vpc-id} $${subnet-id} $${instance-id} $${tcp-flags} $${type} $${pkt-srcaddr} $${pkt-dstaddr}"
# }

resource "aws_subnet" "pub_1" {
  vpc_id = aws_vpc.main.id
  availability_zone = "${var.region}${var.subnet1_suffix}"
  cidr_block = "${var.cidr_prefix}.201.0/24"

  tags = {
    Name = "DEMOpub_${var.subnet1_suffix}_${var.environment}"
  }
}

resource "aws_subnet" "pub_2" {
  vpc_id = aws_vpc.main.id
  availability_zone = "${var.region}${var.subnet2_suffix}"
  cidr_block = "${var.cidr_prefix}.202.0/24"

  tags = {
    Name = "DEMOpub_${var.subnet2_suffix}_${var.environment}"
  }
}

resource "aws_subnet" "priv_app_1" {
  vpc_id = aws_vpc.main.id
  availability_zone = "${var.region}${var.subnet1_suffix}"
  cidr_block = "${var.cidr_prefix}.205.0/24"

  tags = {
    Name = "DEMOpriv_app_${var.subnet1_suffix}_${var.environment}"
  }
}

resource "aws_subnet" "priv_app_2" {
  vpc_id = aws_vpc.main.id
  availability_zone = "${var.region}${var.subnet2_suffix}"
  cidr_block = "${var.cidr_prefix}.206.0/24"

  tags = {
    Name = "DEMOpriv_app_${var.subnet2_suffix}_${var.environment}"
  }
}

resource "aws_subnet" "priv_db_1" {
  vpc_id = aws_vpc.main.id
  availability_zone = "${var.region}${var.subnet1_suffix}"
  cidr_block = "${var.cidr_prefix}.210.0/24"

  tags = {
    Name = "DEMOpriv_db_${var.subnet1_suffix}_${var.environment}"
  }
}

resource "aws_subnet" "priv_db_2" {
  vpc_id = aws_vpc.main.id
  availability_zone = "${var.region}${var.subnet2_suffix}"
  cidr_block = "${var.cidr_prefix}.211.0/24"

  tags = {
    Name = "DEMOpriv_db_${var.subnet2_suffix}_${var.environment}"
  }
}

resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "DEMO${var.environment}"
  }
}

resource "aws_eip" "ngw1" {
  vpc = true
  
  tags = {
    Name = "DEMO${var.environment}"
  }
}

resource "aws_nat_gateway" "ngw_1" {
  allocation_id = aws_eip.ngw1.id
  subnet_id = aws_subnet.pub_1.id
#  depends_on = [aws_internet_gateway.igw1]

  tags = {
    Name = "DEMOpub_${var.subnet1_suffix}_${var.environment}"
  }
}

#resource "aws_nat_gateway" "ngw_2" {
#  allocation_id = aws_eip.ngw1.id
#  subnet_id = aws_subnet.pub_2.id
##  depends_on = [aws_internet_gateway.igw1]
#
#  tags = {
#    Name = "DEMOpub_${var.subnet2_suffix}_{var.environment}"
#  }
#}

##########################################
## Route Tables
# Public Subnet Route Table
resource "aws_route_table" "public1" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "DEMOpub1_${var.environment}"
  }
}

resource "aws_route" "pub1" {
  route_table_id = aws_route_table.public1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw1.id
}

# resource "aws_route" "pub2" {
#   route_table_id = aws_route_table.public1.id
#   destination_cidr_block = "10.0.120.0/23"
#   gateway_id = aws_vpn_gateway.vpn_gw.id
# }

# resource "aws_route" "pub3" {
#   route_table_id = aws_route_table.public1.id
#   destination_cidr_block = "10.0.122.0/23"
#   gateway_id = aws_vpn_gateway.vpn_gw.id
# }

# resource "aws_route" "pub4" {
#   route_table_id = aws_route_table.public1.id
#   destination_cidr_block = "10.0.124.0/23"
#   gateway_id = aws_vpn_gateway.vpn_gw.id
# }

# Private Subnet Route Table
resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "DEMOpriv1_${var.environment}"
  }
}

resource "aws_route" "priv1" {
  route_table_id = aws_route_table.private1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.ngw_1.id
}

# resource "aws_route" "priv2" {
#   route_table_id = aws_route_table.private1.id
#   destination_cidr_block = "10.0.120.0/23"
#   gateway_id = aws_vpn_gateway.vpn_gw.id
# }

# resource "aws_route" "priv3" {
#   route_table_id = aws_route_table.private1.id
#   destination_cidr_block = "10.0.122.0/23"
#   gateway_id = aws_vpn_gateway.vpn_gw.id
# }

# resource "aws_route" "priv4" {
#   route_table_id = aws_route_table.private1.id
#   destination_cidr_block = "${var.peer_ip_prefix}.0.0/16"
#   vpc_peering_connection_id = aws_vpc_peering_connection.peer_connection.id
# }

# resource "aws_route" "priv5" {
#   route_table_id = aws_route_table.private1.id
#   destination_cidr_block = "10.0.124.0/23"
#   gateway_id = aws_vpn_gateway.vpn_gw.id
# }

# Route/Table Associations
resource "aws_route_table_association" "pub_1" {
  subnet_id = aws_subnet.pub_1.id
  route_table_id = aws_route_table.public1.id
}

resource "aws_route_table_association" "pub_2" {
  subnet_id = aws_subnet.pub_2.id
  route_table_id = aws_route_table.public1.id
}

resource "aws_route_table_association" "priv_app_1" {
  subnet_id = aws_subnet.priv_app_1.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "priv_app_2" {
  subnet_id = aws_subnet.priv_app_2.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "priv_db_1" {
  subnet_id = aws_subnet.priv_db_1.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "priv_db_2" {
  subnet_id = aws_subnet.priv_db_2.id
  route_table_id = aws_route_table.private1.id
}

# ######################################
# # Load Balancers
# resource "aws_lb" "ecs1" {
#   name = "ECS-LB-${var.environment}"
# #  internal = false
#   internal = true
#   load_balancer_type = "application"
#   security_groups = [aws_security_group.ecs1_sg.id]
#   subnets = [aws_subnet.priv_app_1.id, aws_subnet.priv_app_2.id]

#   access_logs {
# #    enabled = true
#     enabled = var.flowlogs
#     bucket = aws_s3_bucket.flow_log1.bucket
#   }

#   tags = {
#     Environment = "ECS-LB-${var.environment}"
#   }
# }

# resource "aws_lb_listener" "ecs1" {
#   load_balancer_arn = aws_lb.ecs1.arn
# #  protocol = "HTTPS"
# #  port = "443"
#   protocol = "HTTP"
#   port = 80
# #  certificate_arn = data.aws_acm_certificate.alb.arn
#   default_action {
#     type = "fixed-response"
#     fixed_response {
#       content_type = "text/plain"
#       status_code = 503
#     }
#   }
# }

# gRPC pass through on an ALB requires the HTTPS protocol for the listener.
# ALB SSL certs requires a publicly recognized TLD, so .p3k won't cut it.
# So, until we decide on what we're going to use for a DNS name, if we want
# our devs to be able to test their gRPC apps, we need to set up a network
# load balancer and balance based on TCP.  This is a hacky work around for
# the moment, and will likely be removed.

# # This is now tech debt that we're moving away from the .p3k TLD.
# resource "aws_lb" "ecs2" {
#   name = "ECS-LB-Network-${var.environment}"
#   internal = true
#   load_balancer_type = "network"
#   enable_cross_zone_load_balancing = true
# # security_groups aren't supported on the network load balancers.
# #  security_groups = [aws_security_group.ecs1_sg.id]
#   subnets = [aws_subnet.priv_app_1.id, aws_subnet.priv_app_2.id]


#   access_logs {
# #    enabled = true
#     enabled = var.flowlogs
#     bucket = aws_s3_bucket.flow_log1.bucket
#   }

#   tags = {
#     Environment = "ECS-LB-${var.environment}"
#   }
# }

# resource "aws_lb_listener" "ecs2" {
#   load_balancer_arn = aws_lb.ecs2.arn
#   protocol = "TCP"
#   port = 80
#   default_action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.altg1-stamp-backoffice-rs.arn
#   }
# }

# resource "aws_lb_listener" "ecs3" {
#   load_balancer_arn = aws_lb.ecs2.arn
#   protocol = "TCP"
#   port = 50061
#   default_action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.altg1-stamp-price-service.arn
#   }
# }

# # VPC Peering from Core to STAMP
# resource "aws_vpc_peering_connection" "peer_connection" {
#   provider = aws.oregon
#   vpc_id = var.core_vpc_id
#   peer_vpc_id = aws_vpc.main.id
#   peer_owner_id = var.account_id
#   peer_region = var.region
#   tags = {
#     Name: "${var.environment} ${var.core_region} To ${var.region}"
#   }
# }

# resource "aws_vpc_peering_connection_accepter" "peer_connection" {
#   vpc_peering_connection_id = aws_vpc_peering_connection.peer_connection.id
#   auto_accept               = true
#   tags = {
#     Name: "${var.environment} ${var.core_region} To ${var.region}"
#   }
# }
