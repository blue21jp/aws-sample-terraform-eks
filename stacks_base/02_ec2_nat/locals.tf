locals {
  // Name
  ec2_name = "${local.global.base_vpc.prefix}-nat"

  // NAT Instance AMI
  ami_filters = [
    {
      name   = "name"
      values = ["amzn-ami-vpc-nat*"]
    }
  ]

  // SecurityGroup Ingress
  sg_default_ingress = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      security_groups = []
      self            = true
      cidr_blocks     = []
    },
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      security_groups = []
      self            = false
      cidr_blocks     = [local.global.base_vpc.cidr]
    }
  ]
}
