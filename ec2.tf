################################################################################
# EC2 Instances with for_each in different subnets
################################################################################



module "rds_instances" {
  source = "terraform-aws-modules/ec2-instance/aws"

  for_each = local.rds_instances

  name = each.key

  ami                    = each.value.ami
  subnet_id              = each.value.subnet_id
  instance_type          = "c7i.large"
  key_name               = "datacenter-kp"
  vpc_security_group_ids = ["sg-04567d3b3a1a0670d"]
  user_data              = templatefile("${path.module}/scripts/user_data.tpl", { hostname = each.key })
  metadata_options = {
    http_tokens = "required"
  }

  iam_instance_profile = "ec2-ssm-role"
  enable_volume_tags   = true

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = each.value.root_size
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdh"
      volume_type = "gp3"
      volume_size = each.value.ebs_size
      encrypted   = true
    },
  ]

  disable_api_termination = true
}
