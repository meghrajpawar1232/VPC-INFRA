# Will eventually need to be commented out.  Could be used for reference
# for creating future VPCs, which is why it is left here.
resource "aws_vpc" "main" {
  cidr_block = "20.0.0.0/17"
  enable_dns_hostnames = true
  tags = {
    Name = "Dev-vpc"
  }
}

resource "aws_subnet" "pub_1" {
  vpc_id = aws_vpc.main.id
  availability_zone = "us-east-1a"
  cidr_block = "20.0.0.0/21"

  tags = {
    Name = "dev-pub-1"
  }
   map_public_ip_on_launch = true  # Enable auto-assign public IP addresses
}

resource "aws_subnet" "pub_2" {
  vpc_id = aws_vpc.main.id
  availability_zone = "us-east-1b"
  cidr_block = "20.0.8.0/21"

  tags = {
    Name = "dev-pub-2"
  }
   map_public_ip_on_launch = true  # Enable auto-assign public IP addresses
}

# resource "aws_subnet" "priv_app_1" {
#   vpc_id = aws_vpc.main.id
#   availability_zone = "us-east-1a"
#   cidr_block = "20.0.16.0/21"

#   tags = {
#     Name = "dev-priv-1"
#   }
# }

# resource "aws_subnet" "priv_app_2" {
#   vpc_id = aws_vpc.main.id
#   availability_zone = "us-east-1b"
#   cidr_block = "20.0.24.0/21"

#   tags = {
#     Name = "dev-priv-2"
#   }
# }

# resource "aws_subnet" "priv_db_1" {
#   vpc_id = aws_vpc.main.id
#   availability_zone = "us-east-1a"
#   cidr_block = "20.0.32.0/21"

#   tags = {
#     Name = "dev-db-1"
#   }
# }

# resource "aws_subnet" "priv_db_2" {
#   vpc_id = aws_vpc.main.id
#   availability_zone = "us-east-1b"
#   cidr_block = "20.0.40.0/21"

#   tags = {
#     Name = "dev-db-2"
#   }
# }

resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "dev-igw1"
  }
}

# resource "aws_eip" "ngw1" {
#   vpc = true
  
#   tags = {
#     Name = "dev-eip"
#   }
# }

# resource "aws_nat_gateway" "ngw_1" {
#   allocation_id = aws_eip.ngw1.id
#   subnet_id = aws_subnet.pub_1.id
# #  depends_on = [aws_internet_gateway.igw1]

#   tags = {
#     Name = "dev-nat"
#   }
# }

#resource "aws_nat_gateway" "ngw_2" {
#  allocation_id = aws_eip.ngw1.id
#  subnet_id = aws_subnet.pub_2.id
##  depends_on = [aws_internet_gateway.igw1]
#
#  tags = {
#    Name = "STAMP_pub_${var.subnet2_suffix}_{var.environment}"
#  }
#}

##########################################
## Route Tables
# Public Subnet Route Table
resource "aws_route_table" "public1" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "dev-pub1-rt"
  }
}

resource "aws_route" "pub1" {
  route_table_id = aws_route_table.public1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw1.id
}

resource "aws_route" "pub2" {
  route_table_id = aws_route_table.public1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw1.id
}

# resource "aws_route" "pub3" {
#   route_table_id = aws_route_table.public1.id
#   destination_cidr_block = "20.0.8.0/21"
#   gateway_id = aws_internet_gateway.igw1.id
# }

# resource "aws_route" "pub4" {
#   route_table_id = aws_route_table.public1.id
#   destination_cidr_block = "10.0.124.0/23"
#   gateway_id = aws_vpn_gateway.vpn_gw.id
# }

# Private Subnet Route Table
# resource "aws_route_table" "private1" {
#   vpc_id = aws_vpc.main.id
#   tags = {
#     Name = "dev-private-rt"
#   }
# }

# resource "aws_route" "priv1" {
#   route_table_id = aws_route_table.private1.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id = aws_nat_gateway.ngw_1.id
# }

# resource "aws_route" "priv2" {
#   route_table_id = aws_route_table.private1.id
#   destination_cidr_block = "20.0.16.0/21"
#   gateway_id = aws_nat_gateway.ngw_1.id
# }

# resource "aws_route" "priv3" {
#   route_table_id = aws_route_table.private1.id
#   destination_cidr_block = "20.0.24.0/21"
#   gateway_id = aws_nat_gateway.ngw_1.id
# }

# resource "aws_route" "priv4" {
#   route_table_id = aws_route_table.private1.id
#   destination_cidr_block = "20.0.32.0/21"
#   gateway_id = aws_nat_gateway.ngw_1.id
# }

# resource "aws_route" "priv5" {
#   route_table_id = aws_route_table.private1.id
#   destination_cidr_block = "20.0.40.0/21"
#  gateway_id = aws_nat_gateway.ngw_1.id
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

# resource "aws_route_table_association" "priv_app_1" {
#   subnet_id = aws_subnet.priv_app_1.id
#   route_table_id = aws_route_table.private1.id
# }

# resource "aws_route_table_association" "priv_app_2" {
#   subnet_id = aws_subnet.priv_app_2.id
#   route_table_id = aws_route_table.private1.id
# }

# resource "aws_route_table_association" "priv_db_1" {
#   subnet_id = aws_subnet.priv_db_1.id
#   route_table_id = aws_route_table.private1.id
# }

# resource "aws_route_table_association" "priv_db_2" {
#   subnet_id = aws_subnet.priv_db_2.id
#   route_table_id = aws_route_table.private1.id
# }