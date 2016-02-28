#
variable name                       { default  = "pkrpt" }

variable allocated_storage          { }
variable engine                     { }
variable engine_version             { }
variable family                     { }
variable instance_class             { }
variable password                   { }
variable private_subnet_ids         { }
variable public_subnet_ids          { }
variable route_zone_id              { }
variable sub_domain                 { }
variable vpc_cidr                   { }
variable vpc_id                     { }

variable apply_immediately          { default  = "true" }
variable backup_retention_period    { default  = "7" }
variable backup_window              { default  = "04:14-04:44" }
variable final_snapshot_identifier  { default  = "pkrpt-final" }
variable maintenance_window         { default  = "sun:02:00-sun:02:30" }
variable multi_az                   { default  = "false" }
variable port                       { default  = "3306" }
variable publicly_accessible        { default  = "false" }
variable skip_final_snapshot        { default  = "false" }
variable snapshot_identifier        { default  = "" }
variable storage_encrypted          { default  = "false" }
variable storage_type               { default  = "gp2" }
variable username                   { default  = "dbadmin" }

resource "aws_db_subnet_group" "pkrpt" {
  name = "${var.name}"
  description = "${var.name}"
  subnet_ids = ["${split(",", var.private_subnet_ids)}"]

  tags { Name = "${var.name}" }
}

resource "aws_security_group" "pkrpt" {
  name   = "${var.name}"
  vpc_id = "${var.vpc_id}"

  tags      { Name = "${var.name}" }
  lifecycle { create_before_destroy = true }

  ingress {
    protocol    = "tcp"
    from_port   = "${var.port}"
    to_port     = "${var.port}"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route53_record" "pkrpt" {
  zone_id = "${var.route_zone_id}"
  name    = "pkrpt.${var.sub_domain}"
  type    = "CNAME"
  ttl     = "5"
  records = ["${aws_db_instance.pkrpt.address}"]
}

resource "aws_db_parameter_group" "pkrpt" {
  name        = "${var.name}"
  family      = "${var.family}"
  description = "${var.name}"

  parameter  { name = "binlog_format"                 value = "row" }
  parameter  { name = "binlog_checksum"               value = "none" }
  parameter  { name = "character_set_client"          value = "utf8" }
  parameter  { name = "character_set_server"          value = "utf8" }
  parameter  { name = "event_scheduler"               value = "on" }
  parameter  { name = "log_queries_not_using_indexes" value = "1" }
  parameter  { name = "lower_case_table_names"        value = "1" apply_method = "pending-reboot" }

  /*
    parameter { name = "thread_cache_size"              value = "16"  }
    parameter { name = "innodb_flush_log_at_trx_commit" value = "2"  }
    */

  /*
    Terraform/ec2 only allows you to modify 20 params at a shot. There are 
    over a hundred config options to rds params. WTF.

    parameter { name = "innodb_write_io_threads"          value = "16" }
    parameter { name = "innodb_flush_log_at_trx_commit"   value = "0" }
    parameter { name = "query_cache_size"                 value = "536870912" }
    parameter { name = "slow_query_log"                   value = "1" }
    parameter { name = "table_open_cache"                 value = "10000" }
    parameter { name = "tx_isolation"                     value = "READ-COMMITTED" }
    parameter { name = "max_allowed_packet"               value = "33554432" }
    parameter { name = "performance_schema"               value = "1" }
    parameter { name = "query_cache_limit"                value = "2000000" }
    parameter { name = "innodb_max_dirty_pages_pct"       value = "90" }
    parameter { name = "innodb_read_io_threads"           value = "16" }
    parameter { name = "log_bin_trust_function_creators"  value = "1" }
    parameter { name = "query_cache_type"                 value = "1" }
    */
}

resource "aws_db_instance" "pkrpt" {
  allocated_storage         = "${var.allocated_storage}"
  apply_immediately         = "${var.apply_immediately}"
  backup_retention_period   = "${var.backup_retention_period}"
  backup_window             = "${var.backup_window}"
  db_subnet_group_name      = "${aws_db_subnet_group.pkrpt.id}"
  engine                    = "${var.engine}"
  engine_version            = "${var.engine_version}"
  final_snapshot_identifier = "${var.final_snapshot_identifier}"
  identifier                = "${var.name}"
  instance_class            = "${var.instance_class}"
  maintenance_window        = "${var.maintenance_window}"
  multi_az                  = "${var.multi_az}"
  parameter_group_name      = "${aws_db_parameter_group.pkrpt.name}"
  password                  = "${var.password}"
  port                      = "${var.port}"
  publicly_accessible       = "${var.publicly_accessible}"
  snapshot_identifier       = "${var.snapshot_identifier}"
  skip_final_snapshot       = "${var.skip_final_snapshot}"
  storage_encrypted         = "${var.storage_encrypted}"
  storage_type              = "${var.storage_type}"
  username                  = "${var.username}"
  vpc_security_group_ids    = ["${aws_security_group.pkrpt.id}"]

  depends_on = ["aws_db_parameter_group.pkrpt", "aws_security_group.pkrpt"]

  tags      { Name = "${var.name}" }

}
