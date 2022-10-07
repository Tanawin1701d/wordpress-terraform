#STEP create ec2 instance

data "template_file" "write_scripts" {
  template = file("db_file/write_db.cfg")
  vars = {
    database_user     = var.database_user,
    database_name     = var.database_name,
    database_pass     = var.database_pass,
    sec2_net_inf_addr = var.sec2_net_inf_addr
  }
}

data "local_file" "packages_scripts" {
  filename = "db_file/package_db.cfg"
}

data "cloudinit_config" "prov_db" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.local_file.packages_scripts.content
  }
  part {
    content_type = "text/cloud-config"
    content      = data.template_file.write_scripts.rendered
  }

}

resource "aws_instance" "inst1_ec2" {
  ami               = var.ami
  instance_type     = var.inst_type
  key_name          = aws_key_pair.my_key.id
  availability_zone = var.availability_zone
  depends_on = [
    aws_subnet.sec1_sn_pub,
    aws_route_table.sec1_nat_rtb_pub,
    aws_eip.sec1_eip_db,
    aws_nat_gateway.sec1_ngw,
    aws_route_table.sec1_rtb,
    aws_subnet.sec1_priv_sn,
    aws_security_group.sec1_sg,
    aws_network_interface.sec1_net_itf,
    aws_route_table_association.sec1_rtb_sn_ass,
    aws_route_table_association.sec1_rtb_sn_nat_ass
  ]


  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.sec1_net_itf.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.sec2_net_itf_db.id
  }

  user_data = data.cloudinit_config.prov_db.rendered

  tags = {
    "Name" = "inst1_ec2"
  }

}