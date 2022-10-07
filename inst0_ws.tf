#STEP build ec2 instance

data "template_file" "ws_write_scripts" {
  template = file("ws_file/write_ws.cfg")
  vars = {
    var_db_name          = var.database_name
    var_db_user          = var.database_user
    var_db_pass          = var.database_pass
    var_db_host          = var.sec2_net_inf_addr2
    var_db_port          = var.inst_db_port
    var_s3_bucket_name   = var.bucket_name
    var_s3_bucket_region = aws_s3_bucket.ws_s3_bucket.region
    # account initialization
    var_ws_usr         = "ubuntu"
    var_ws_url         = "http://${aws_eip.sec0_eip_ws.public_ip}/wordpress"
    var_ws_title       = var.wp_title
    var_ws_admin_user  = var.admin_user
    var_admin_pass     = var.admin_pass
    var_db_port        = var.inst_db_port
    var_ws_admin_email = var.wp_email
    ####
    #wp security
    AUTH_KEY         = var.wp_AUTH_KEY
    SECURE_AUTH_KEY  = var.wp_SECURE_AUTH_KEY
    LOGGED_IN_KEY    = var.wp_LOGGED_IN_KEY
    NONCE_KEY        = var.wp_NONCE_KEY
    AUTH_SALT        = var.wp_AUTH_SALT
    SECURE_AUTH_SALT = var.wp_SECURE_AUTH_SALT
    LOGGED_IN_SALT   = var.wp_LOGGED_IN_SALT
    NONCE_SALT       = var.wp_NONCE_SALT
  }
}

data "cloudinit_config" "prov_ws" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.ws_write_scripts.rendered
  }

}


resource "aws_key_pair" "my_key" {
  key_name   = "mykey2"
  public_key = file(var.ec2_pubKey_src)
}

resource "aws_instance" "inst0_ec2" {
  ami           = var.ami
  instance_type = var.inst_type
  key_name      = aws_key_pair.my_key.id
  depends_on = [
    aws_instance.inst1_ec2,
    aws_internet_gateway.sec0_gw,
    aws_route.sec0_route,
    aws_route_table.sec0_rtb,
    aws_subnet.sec0_sn,
    aws_route_table_association.sec0_rtb_sn_ass,
    aws_security_group.sec0_sg,
    aws_network_interface.sec0_net_itf
  ]
  iam_instance_profile = aws_iam_instance_profile.ws_s3_iam_profile.id
  availability_zone    = var.availability_zone

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.sec0_net_itf.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.sec2_net_itf_ws.id
  }

  user_data = data.cloudinit_config.prov_ws.rendered



  tags = {
    "Name" = "inst0_ec2"
  }

}


