
terraform {
  required_version = ">= 0.12.26"
}

data "aws_iam_policy_document" "consul_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "consul_agent" {
  name               = "consul-agent"
  assume_role_policy = data.aws_iam_policy_document.consul_agent.json
}


resource "aws_iam_role_policy_attachment" "consul_agent" {
  role       = aws_iam_role.consul_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"

}

resource "aws_iam_instance_profile" "consul_agent" {
  name = "consul-agent"
  role = aws_iam_role.consul_agent.name
}



resource "aws_launch_configuration" "consul_launch_config" {
    image_id             = var.ami_id
    iam_instance_profile = aws_iam_instance_profile.consul_agent.name
    security_groups      = [aws_security_group.consul_sg.id]
    user_data            = var.user_data
    instance_type        = var.instance_type
}

resource "aws_autoscaling_group" "autoscaling_group" {
    name                      = var.cluster_name
    vpc_zone_identifier       = var.subnet_ids
    launch_configuration      = aws_launch_configuration.consul_launch_config.name

    min_size             = var.cluster_size
    max_size             = var.cluster_size
    desired_capacity     = var.cluster_size
    health_check_grace_period = 300
    health_check_type         = "EC2"
}
resource "aws_security_group" "consul_sg" {
    vpc_id      = var.vpc_id

    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}
