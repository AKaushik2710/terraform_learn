!#/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install apache2 -y

sudo systemctl start apache2

sudo systemctl enable apache2

echo "<h1> Hello</h1>" > /var/www/html/index.html


