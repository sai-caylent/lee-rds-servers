################################################################################
# EC2 Instances with for_each in different subnets
################################################################################
locals {
  rds_instances = {
    "leeapp-rdchost1" = {
      subnet_id = data.aws_subnet.private_b.id
      ami       = var.ami_2016
      root_size = 30
      ebs_size  = 200
    }
    "sbsdb2" = {
      subnet_id = data.aws_subnet.private_b.id
      ami       = var.ami_2022
      root_size = 40
      ebs_size  = 75
    }
    "sbsweb1" = {
      subnet_id = data.aws_subnet.private_a.id
      ami       = var.ami_2022
      root_size = 40
      ebs_size  = 75
    }
  }
}
