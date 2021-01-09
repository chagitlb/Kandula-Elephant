module "consul_cluster" {

    cluster_name = var.cluster_name
    source = "./ConsulModule"
    ami_id = data.aws_ami.ubuntu.id
    cluster_tag_key   = "consul-cluster"
    cluster_tag_value = "consul-cluster-example"
    cluster_size = 3
    instance_type = "t2.micro"
    vpc_id = module.vpc.vpc_id
    allowed_inbound_cidr_blocks = var.cidr_public
    subnet_ids = module.vpc.public_subnets
    availability_zones = var.availability_zones
    ssh_key_name = aws_key_pair.terraform-key.key_name
    associate_public_ip_address = true
    user_data = file("consul-server.sh")
    depends_on = [module.vpc]

}

# resource "aws_consul_cluster" "consul_cluster" {
#     name  = var.cluster_name
# }