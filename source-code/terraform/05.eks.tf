module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = "supphakit_clus"
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = "vpc-b8d13ade"
  subnet_ids = ["subnet-6221ed2a", "subnet-7e65ee27", "subnet-977ea2f1"]
  
  #   cluster_addons = {
  #     coredns = {
  #       resolve_conflicts = "OVERWRITE"
  #     }
  #     kube-proxy = {}
  #     vpc-cni = {
  #       resolve_conflicts = "OVERWRITE"
  #     }
  #   }

  #   cluster_encryption_config = [{
  #     provider_key_arn = "ac01234b-00d9-40f6-ac95-e42345f78b00"
  #     resources        = ["secrets"]
  #   }]


  #   # Self Managed Node Group(s)
  #   self_managed_node_group_defaults = {
  #     instance_type                          = "t3.medium"
  #     update_launch_template_default_version = true
  #     iam_role_additional_policies           = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  #   }

  #   self_managed_node_groups = {
  #     one = {
  #       name = "banjo_selfmanagednode3"

  #       public_ip    = true
  #       max_size     = 3
  #       desired_size = 1

  #       use_mixed_instances_policy = true
  #       mixed_instances_policy = {
  #         instances_distribution = {
  #           on_demand_base_capacity                  = 0
  #           on_demand_percentage_above_base_capacity = 10
  #           spot_allocation_strategy                 = "capacity-optimized"
  #         }

  #         override = [
  #           {
  #             instance_type     = "t3.medium"
  #             weighted_capacity = "1"
  #           },
  #           {
  #             instance_type     = "t3.medium"
  #             weighted_capacity = "2"
  #           },
  #         ]
  #       }

  #       pre_bootstrap_user_data = <<-EOT
  #       echo "foo"
  #       export FOO=bar
  #       EOT

  #       bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"

  #       post_bootstrap_user_data = <<-EOT
  #       cd /tmp
  #       sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
  #       sudo systemctl enable amazon-ssm-agent
  #       sudo systemctl start amazon-ssm-agent
  #       EOT
  #     }
  #   }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    disk_size      = 20
    instance_types = ["t3.medium"]
    # vpc_security_group_ids = ["sg-030afe75"]
  }

  eks_managed_node_groups = {
    sup_node = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.medium"]
      capacity_type = "ON_DEMAND"
    }
  }

  #   tags = {
  #     Environment = "dev"
  #     Terraform   = "true"
  #   }
}


resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = module.eks.eks_managed_node_groups.sup_node.node_group_resources[0].autoscaling_groups[0].name
  alb_target_group_arn   = module.nlb.target_group_arns[0]
}


resource "aws_security_group_rule" "access_rule" {
  type        = "ingress"
  description = "all port ggze"
  from_port   = 0
  to_port     = 30080
  protocol    = "all"
  # cidr_blocks      = [aws_vpc.main.cidr_block]
  # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  security_group_id = module.eks.eks_managed_node_groups.sup_node.security_group_id
  # self = false
  cidr_blocks = ["0.0.0.0/0"]
}
