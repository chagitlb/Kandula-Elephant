module "public_servers" {
  source           = "./InstanceModule"
  name            = "${var.env_name} public server"
  subnets          = module.vpc.public_subnets
  instance_type   = var.instance_type
  ami_id           = data.aws_ami.ubuntu.id
  key_name         = aws_key_pair.terraform-key.key_name
  security_groups  = [aws_security_group.web.id]
  user_data        = var.nginx_install
  tags             = {Name = "Jenkins server"}
}

module "private_servers" {
  source          = "./InstanceModule"
  count           = 2
  name            = "${var.env_name} private server"
  subnets         = module.vpc.private_subnets
  instance_type   = var.instance_type
  ami_id          = data.aws_ami.ubuntu.id
  key_name        = aws_key_pair.terraform-key.key_name
  security_groups = [aws_security_group.db.id]
  user_data       = null
  tags = {
          Name = "jenkins node"
          }
}

resource "aws_instance" "jenkins_master" {
  count                  = 1
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnet[count.index]
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = var.key_name
  associate_public_ip_address = true
  user_data              = file(install_jenkins.sh)
  Name = "Jenkins-Master"
  }



resource "aws_instance" "jenkins_slave" {
  count                  = 2
  ami                    = module.vpc.aws_ami_id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.private_subnets
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = var.key_name
  tags = {
    Name = "Jenkins-Slave-${count.index}"
  }
}