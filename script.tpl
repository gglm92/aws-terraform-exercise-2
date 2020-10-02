#!/bin/bash
# Install httpd
sudo yum install -y httpd
# Start httpd
sudo service httpd start

#Modify index.html
sudo -i
hostname > /var/www/html/index.html