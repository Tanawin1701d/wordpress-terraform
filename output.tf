# #STEP output

output "ws_public_wordpress" {
  value = "http://${aws_instance.inst0_ec2.public_ip}/wordpress/wp-admin"
}
output "db_public_ip" {
  value = aws_instance.inst1_ec2.public_ip
}

output "db_sg_allowed_ip"{
  value = "${cidrhost("${var.sec2_net_inf_addr}/32", 0)}/32"

}