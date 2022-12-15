# Part1 and Part2 need to be used together in an environment. Part1 has the provider, so Part2 doesn't need it. Hence commenting.
provider "aws" {
  
  region     = "ca-central-1" //Canada
}
# Create AWS Certificate Manager
resource "aws_acm_certificate" "acqa-test-acm1" {
  domain_name       = "acqatest.com"
  validation_method = "DNS"
  tags = {
    Name         = format("%s-acm1", var.acqaPrefix)
    ACQAResource = "true"
    Owner        = "AC-QA"
    "jet:metadata:owner"        = "Infosec"
    "jet:metadata:dept"         = "Cloudsec"
    "jet:metadata:feature"      = "Cloudquery"
  }
  lifecycle {
    create_before_destroy = true
  }
}
# Create SSM parameter resource
resource "aws_ssm_parameter" "acqa-test-ssmparam3" {
  name  = "acqa-test-ssmparam3"
  type  = "String"
  value = "bar"
  tags = {
    Name         = format("%s-ssmparam1", var.acqaPrefix)
    ACQAResource = "true"
    Owner        = "AC-QA"
    "jet:metadata:owner"        = "Infosec"
    "jet:metadata:dept"         = "Cloudsec"
    "jet:metadata:feature"      = "Cloudquery"
  }
}
# Create customer gateway
resource "aws_customer_gateway" "acqa-test-cgateway1" {
  bgp_asn    = 65000
  ip_address = "172.83.124.10"
  type       = "ipsec.1"
  # Tags
  tags = {
    Name         = format("%s-cgateway1", var.acqaPrefix)
    ACQAResource = "true"
    Owner        = "AC-QA"
    "jet:metadata:owner"        = "Infosec"
    "jet:metadata:dept"         = "Cloudsec"
    "jet:metadata:feature"      = "Cloudquery"
  }
}
#Transit Gateway
resource "aws_ec2_transit_gateway" "acqa-test-ec2-tgateway1" {
  description = "acqa-test-ec2-tgateway1"
  # Tags
  tags = {
    Name         = format("%s-ec2-tgateway1", var.acqaPrefix)
    ACQAResource = "true"
    Owner        = "AC-QA"
    "jet:metadata:owner"        = "Infosec"
    "jet:metadata:dept"         = "Cloudsec"
    "jet:metadata:feature"      = "Cloudquery"
  }
}
# Budget
resource "aws_budgets_budget" "acqa-test-budget3" {
  name              = "acqa-test-budget3"
  budget_type       = "COST"
  limit_amount      = "1200.0"
  limit_unit        = "USD"
  time_period_end   = "2087-06-15_00:00"
  time_period_start = "2017-07-01_00:00"
  time_unit         = "MONTHLY"
  cost_filters = {
    Service = "Amazon Elastic Compute Cloud - Compute"
  }
  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = ["test@example.com"]
  }
}
# IOT Thing
resource "aws_iot_thing" "acqa-test-iotthing1" {
  name = "acqa-test-iotthing1"
  attributes = {
    First = "acqa-test-iotthing1"
  }
}
# Cloud9 Environment
resource "aws_cloud9_environment_ec2" "acqa-test-c9ev3" {
  instance_type = "t2.micro"
  name          = "acqa-test-c9ev3"
  # Tags
  tags = {
    ACQAResource = "true"
    Owner        = "AC-QA"
    "jet:metadata:owner"        = "Infosec"
    "jet:metadata:dept"         = "Cloudsec"
    "jet:metadata:feature"      = "Cloudquery"
  }
}
# # RDS - Mysql
# resource "aws_db_instance" "acqatestrdsmysqlone" {
#   allocated_storage    = 200
#   identifier           = "acqatestrdsmysqlone"
#   storage_type         = "gp2"
#   engine               = "mysql"
#   engine_version       = "5.7"
#   instance_class       = "db.m5.xlarge"
#   name                 = "acqatestrdsmysqlone"
#   username             = "foo"
#   password             = "foobarbaz"
#   parameter_group_name = "default.mysql5.7"
#   tags = {
#     ACQAResource = "true"
#     Name         = "acqatestrdsmysqlone"
#     Owner        = "ACQA"
#   }
#   skip_final_snapshot             = true
#   final_snapshot_identifier       = "acqatestrdsmysqlonesnapshot"
#   domain                          = "<domain>"
#   # enabled_cloudwatch_logs_exports = "<enabled_cloudwatch_logs_exports>"
#   storage_encrypted               = true
#   performance_insights_enabled    = true
#   backup_retention_period         = 30
#   deletion_protection             = true
# }
# # RDS - PGSQL
# resource "aws_db_instance" "acqatestrdspgsqlone" {
#   allocated_storage    = 200
#   identifier           = "acqatestrdspgsqlone"
#   storage_type         = "gp2"
#   engine               = "postgres"
#   engine_version       = "13.4"
#   instance_class       = "db.m5.xlarge"
#   name                 = "acqatestrdspgsqlone"
#   username             = "foo"
#   password             = "foobarbaz"
#   parameter_group_name = "default.postgres9.6"
#   tags = {
#     ACQAResource = "true"
#     Name         = "acqatestrdspgsqlone"
#     Owner        = "ACQA"
#   }
#   skip_final_snapshot             = true
#   final_snapshot_identifier       = "acqatestrdspgsqlonesnapshot"
#   domain                          = "<domain>"
#   # enabled_cloudwatch_logs_exports = "<enabled_cloudwatch_logs_exports>"
#   storage_encrypted               = true
#   performance_insights_enabled    = true
#   backup_retention_period         = 30
#   deletion_protection             = true
# }
resource "aws_security_group" "km_alb_sg1" {
  name        = "km_alb_sg1"
  description = "controls access to the ALB"
  vpc_id      = "vpc-0dcfc6c7488b848c7"
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}
# Example SES Domain Identity
resource "aws_ses_domain_identity" "acqa-test-asdi1" {
  domain = "acqatestasdi1.com"
}
# Simple Email Service Domain
resource "aws_ses_domain_mail_from" "acqa-test-sesdom1" {
  domain           = aws_ses_domain_identity.acqa-test-asdi1.domain
  mail_from_domain = "bounce.${aws_ses_domain_identity.acqa-test-asdi1.domain}"
}
