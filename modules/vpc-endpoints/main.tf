resource "aws_vpc_endpoint" "ssm_endpoint" {
  vpc_id = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [var.private_subnet_a_id,var.private_subnet_b_id]
  security_group_ids = [var.sg_ssm]
  private_dns_enabled = true

}
