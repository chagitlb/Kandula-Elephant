variable "kubernetes_version" {
  default = 1.18
  description = "kubernetes version"
}

variable "cluster_name" {
  default = "opsschool-cluster"
}
variable "cluster_size" {
  default     = 3
}

variable "cluster_tag_key" {
  default     = "consul-servers"
}

variable "cluster_tag_value" {
  default     = "auto-join"
}
locals {
  k8s_service_account_namespace = "default"
  k8s_service_account_name      = "opsschool-sa"
}
variable "aws_region" {
  default = "us-east-1"
  description = "aws region"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "cidr_vpc" {
  type    = string
  default = "10.100.0.0/16"
}

variable "cidr_public" {
  type    = list(string)
  default = ["10.100.1.0/24", "10.100.2.0/24"]
}

variable "cidr_private" {
  type    = list(string)
  default = ["10.100.10.0/24", "10.100.11.0/24"]
}
variable "env_name"{
    default = "prod"
}
variable "instance_type" {
  type        = string
  default     = "t2.micro"
}
variable "assume_role_policy_data" {
  type    = string
  default = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
      }
    ]
  }
  EOF
}
variable "nginx_install" {
  description = "Install nginx on web servers"
  type        = string
  default     = <<-EOF
    #!/bin/bash
    sudo yum install nginx -y
    sudo chmod +x /usr/share/nginx/html/index.html
    cd /usr/share/nginx/html
    { echo '<html>';
    echo '<body>';
    echo '<h1>Opsschool Rules</h1>';
    echo '</body>';
    echo '</html>';} > index.html
    sudo service nginx start
  EOF
}