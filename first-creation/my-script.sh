#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install apache2 -y

sudo systemctl start apache2

sudo systemctl enable apache2

sudo su 

echo "<!DOCTYPE html>
<html>
<head>
<title>Page Title</title>
</head>
<body>

<h1>This is a Heading</h1>
<p>This is a paragraph.</p>

</body>
</html>" > /var/www/html/index.html

# sudo systemctl start apache2

# sudo systemctl enable apache2
