#!/bin/bash
cd /tmp/ws_file
# install dependency
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

sudo apt-get update -y
sudo apt-get install apache2 -y
sudo apt-get install mariadb-client -y
sudo apt-get install php php-mysql -y
sudo apt-get install php7.4-curl -y
sudo apt-get install php-xml -y
# download wordpress
wget https://wordpress.org/wordpress-6.0.2.tar.gz
tar -xzvf wordpress-6.0.2.tar.gz
sleep 10
sudo cp -R wordpress /var/www/html/wordpress
sudo chown -R www-data:www-data /var/www/html/wordpress/
sudo usermod -a -G www-data ubuntu
#sudo chmod -R 755 /var/www/html/wordpress/
#sudo chmod -R 755 /var/www/html/wordpress/wp-content
#sudo chmod -R 755 /var/www/html/wordpress/wp-content/plugins
sudo mkdir /var/www/html/wordpress/wp-content/uploads
sudo chown -R www-data:www-data /var/www/html/wordpress/wp-content/uploads/
# wordpress config
#sudo chmod 755 wp-config.php 
sudo cp wp-config.php /var/www/html/wordpress/wp-config.php


#wordpress cli + plugin install
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

sudo chmod -R 775 /var/www/html/wordpress/
#wp core install --path=/var/www/html/wordpress/ --url=${var_ws_url} --title=${var_ws_title} --admin_user=${var_ws_admin_user} --admin_email=${var_ws_admin_email} --admin_password=${var_admin_pass}
#wp plugin install  amazon-s3-and-cloudfront --activate --path=/var/www/html/wordpress/
#sudo chmod -R 755 /var/www/html/wordpress/
# restart apache2
sudo service apache2 restart
