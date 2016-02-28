#--------------------------------------------------------------
# This module creates all data resources
#--------------------------------------------------------------

variable "name"                     { }
variable "region"                   { }
variable "vpc_id"                   { }
variable "vpc_cidr"                 { }
variable "private_subnet_ids"       { }
variable "public_subnet_ids"        { }
variable "ssl_cert"                 { }
variable "ssl_key"                  { }
variable "key_name"                 { }
variable "atlas_username"           { }
variable "atlas_environment"        { }
variable "atlas_token"              { }
variable "sub_domain"               { }
variable "route_zone_id"            { }

variable "bastion_host"             { }
variable "bastion_user"             { }

variable "consul_amis"              { }
variable "consul_instance_type"     { }
variable "consul_node_count"        { }

variable "openvpn_host"             { }
variable "openvpn_user"             { }
variable "private_key"              { }

variable "pkrpt_allocated_storage"  { }
variable "pkrpt_engine"             { }
variable "pkrpt_engine_version"     { }
variable "pkrpt_family"             { }
variable "pkrpt_instance_class"     { }
variable "pkrpt_password"           { }

variable "vault_amis"               { }
variable "vault_node_count"         { }
variable "vault_instance_type"      { }

module "consul" {
  source = "./consul"
  name               = "${var.name}-consul"

  amis               = "${var.consul_amis}"
  atlas_environment  = "${var.atlas_environment}"
  atlas_token        = "${var.atlas_token}"
  atlas_username     = "${var.atlas_username}"
  bastion_host       = "${var.bastion_host}"
  bastion_user       = "${var.bastion_user}"
  instance_type      = "${var.consul_instance_type}"
  key_name           = "${var.key_name}"
  nodes              = "${var.consul_node_count}"
  openvpn_host       = "${var.openvpn_host}"
  openvpn_user       = "${var.openvpn_user}"
  private_key        = "${var.private_key}"
  private_subnet_ids = "${var.private_subnet_ids}"
  vpc_cidr           = "${var.vpc_cidr}"
  vpc_id             = "${var.vpc_id}"
}

module "vault" {
  source = "./vault"
  name               = "${var.name}-vault"

  amis               = "${var.vault_amis}"
  atlas_environment  = "${var.atlas_environment}"
  atlas_token        = "${var.atlas_token}"
  atlas_username     = "${var.atlas_username}"
  instance_type      = "${var.vault_instance_type}"
  key_name           = "${var.key_name}"
  nodes              = "${var.vault_node_count}"
  private_subnet_ids = "${var.private_subnet_ids}"
  public_subnet_ids  = "${var.public_subnet_ids}"
  region             = "${var.region}"
  route_zone_id      = "${var.route_zone_id}"
  ssl_cert           = "${var.ssl_cert}"
  ssl_key            = "${var.ssl_key}"
  sub_domain         = "${var.sub_domain}"
  vpc_cidr           = "${var.vpc_cidr}"
  vpc_id             = "${var.vpc_id}"
}

module "pkrpt" {
  source = "./pkrpt"
  name                 = "${var.name}-pkrpt"

  allocated_storage  = "${var.pkrpt_allocated_storage}"
  engine             = "${var.pkrpt_engine}"
  engine_version     = "${var.pkrpt_engine_version}"
  family             = "${var.pkrpt_family}"
  instance_class     = "${var.pkrpt_instance_class}"
  password           = "${var.pkrpt_password}"
  private_subnet_ids = "${var.private_subnet_ids}"
  public_subnet_ids  = "${var.public_subnet_ids}"
  route_zone_id      = "${var.route_zone_id}"
  sub_domain         = "${var.sub_domain}"
  vpc_cidr           = "${var.vpc_cidr}"
  vpc_id             = "${var.vpc_id}"
}

# Consul
output "consul_private_ips" { value = "${module.consul.private_ips}" }

# Vault
output "vault_private_ips"  { value = "${module.vault.private_ips}" }
output "vault_elb_dns"      { value = "${module.vault.elb_dns}" }
output "vault_private_fqdn" { value = "${module.vault.private_fqdn}" }

# PkRPT

