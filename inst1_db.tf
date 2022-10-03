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

data "local_file" "run_scripts" {
  filename = "db_file/run_db.cfg"
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
  part {
    content_type = "text/cloud-config"
    content      = data.local_file.run_scripts.content

  }
}

resource "aws_instance" "inst1_ec2" {
  ami               = var.ami
  instance_type     = "t2.micro"
  key_name          = aws_key_pair.my_key.id
  availability_zone = var.availability_zone


  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.sec1_net_itf.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.sec2_net_itf_db.id
  }

  user_data = data.cloudinit_config.prov_db.rendered


  #  <<-EOF
  #               #!/bin/bash
  #               while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done
  #               sudo apt update -y
  #               cd /tmp/
  #               sudo apt-get install mariadb-server  -y

  #               echo "CREATE DATABASE ${var.database_name};
  #                     CREATE USER '${var.database_user}'@'${var.sec2_net_inf_addr}' IDENTIFIED BY '${var.database_pass}';
  #                     GRANT ALL ON ${var.database_name}.* TO '${var.database_user}'@'${var.sec2_net_inf_addr}' IDENTIFIED BY '${var.database_pass}';
  #                     FLUSH PRIVILEGES;
  #                     exit;" > initial.sql
  #               sudo mysql < initial.sql
  #               sudo echo "bind-address = 0.0.0.0" >> /etc/mysql/my.cnf
  #               sudo service mariadb restart
  #               EOF


  tags = {
    "Name" = "inst1_ec2"
  }

}