module "nlb" {
  source = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"
  name = "sup-alb"
  load_balancer_type = "network"

  vpc_id  = "vpc-b8d13ade"
  subnets = ["subnet-977ea2f1", "subnet-6221ed2a", "subnet-7e65ee27"]

  # access_logs = { 
  #   bucket  = "bucketbkk"
  #   prefix  = "logs"
  #   enabled = true
  # }

  target_groups = [
    {
      name_prefix      = "sup"
      backend_protocol = "TCP"
      backend_port     = 30080
      target_type      = "instance"
    }
  ]
  #   https_listeners = [
  #     {
  #       port               = 443
  #       protocol           = "TLS"
  #       certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
  #       target_group_index = 0
  #     }
  #   ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    }
  ]

  #   tags = {
  #     Environment = "Test"
  #   }
}