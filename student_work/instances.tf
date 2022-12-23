# INSTANCES #
resource "aws_instance" "nginxs" {
  count                  = var.instance_count
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.aws_instance_type
  subnet_id              = module.vpc.public_subnets[(count.index % var.vpc_subnet_count)]
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  iam_instance_profile   = module.web_app_s3.nginx_instance_profile.name
  depends_on             = [module.web_app_s3]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-instance-${count.index}"
  })

  user_data = templatefile("${path.module}/startup_script.tpl", {
    s3_bucket_name = module.web_app_s3.bucket.id
  })

}
