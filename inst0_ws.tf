#STEP build ec2 instance

# data "template_file" "wp_conf" {
#   template = file("ws_file/wp-config.php")
#   vars = {
#     var_db_name          = var.database_name
#     var_db_user          = var.database_user
#     var_db_pass          = var.database_pass
#     var_db_host          = var.sec2_net_inf_addr2
#     var_db_port          = var.inst_db_port
#     var_s3_bucket_name   = var.bucket_name
#     var_s3_bucket_region = var.region
#   }
# }

# data "template_file" "ws_install" {
#   template = file("ws_file/run.sh")
#   vars = {
#     var_ws_url         = "${aws_eip.sec0_eip_ws.public_ip}"
#     var_ws_title       = "test"
#     var_ws_admin_user  = var.admin_user
#     var_admin_pass     = var.admin_pass
#     var_db_port        = var.inst_db_port
#     var_ws_admin_email = "newskscholar@gmail.com"
#   }
# }


data "template_file" "ws_write_scripts" {
  template = file("ws_file/write_ws.cfg")
  vars = {
    var_db_name          = var.database_name
    var_db_user          = var.database_user
    var_db_pass          = var.database_pass
    var_db_host          = var.sec2_net_inf_addr2
    var_db_port          = var.inst_db_port
    var_s3_bucket_name   = var.bucket_name
    var_s3_bucket_region = var.region
    # account initialization
    var_ws_usr           = "ubuntu"
    var_ws_url           = "http://${aws_eip.sec0_eip_ws.public_ip}/wordpress"
    var_ws_title         = "test"
    var_ws_admin_user    = var.admin_user
    var_admin_pass       = var.admin_pass
    var_db_port          = var.inst_db_port
    var_ws_admin_email   = "example@gmail.com"
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
  public_key = file("/home/tanawin/.aws/mykey2.pub")
}

resource "aws_instance" "inst0_ec2" {
  ami                  = var.ami
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.my_key.id
  depends_on           = [aws_instance.inst1_ec2]
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


  # provisioner "remote-exec" {

  #   inline = [" mkdir -p /tmp/ws_file/"]

  #   connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     host        = self.public_ip
  #     private_key = file("./mykey2")
  #   }
  # }

  # provisioner "file" {
  #   content     = data.template_file.ws_install.rendered
  #   destination = "/tmp/ws_file/run.sh"

  #   connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     host        = self.public_ip
  #     private_key = file("./mykey2")
  #   }
  # }

  # provisioner "file" {
  #   source     = "./mykey2"
  #   destination = "/home/ubuntu/mykey"

  #   connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     host        = self.public_ip
  #     private_key = file("./mykey2")
  #   }
  # }

  # provisioner "file" {
  #   content     = data.template_file.wp_conf.rendered
  #   destination = "/tmp/ws_file/wp-config.php"

  #   connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     host        = self.public_ip
  #     private_key = file("./mykey2")
  #   }
  # }

  # provisioner "remote-exec" {

  #   inline = ["sudo chmod +x /tmp/ws_file/run.sh",
  #     "/tmp/ws_file/run.sh",
  #     "sudo chmod 400 /home/ubuntu/mykey"
  #   ]

  #   connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     host        = self.public_ip
  #     private_key = file("./mykey2")
  #   }
  # }


  tags = {
    "Name" = "inst0_ec2"
  }

}


# #STEP output

# output "ws_private_ip" {
#   value = aws_instance.proj_ws_ec2.private_ip
# }

# output "ws_public_ip" {
#   value = aws_eip.proj_ws_eip.public_ip
# }
output "ws_public_wordpress" {
  value = "${aws_instance.inst0_ec2.public_ip}/wordpress"
}