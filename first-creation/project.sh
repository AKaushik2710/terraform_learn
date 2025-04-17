#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install apache2 -y

sudo systemctl start apache2

sudo systemctl enable apache2

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash

# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"

# Download and install Node.js:
nvm install 22

# Verify the Node.js version:
node -v # Should print "v22.14.0".

nvm current # Should print "v22.14.0".

# Verify npm version:
npm -v # Should print "10.9.2".

git clone https://github.com/nayanrdeveloper/todo_list.git

cd to*/b*

npm install

npm install -g pm2

pm2 start app.js  # Replace app.js with your main file

pm2 startup

pm2 save

cd ../f*/

npm install

npm run build

sudo cp -r dist/* /var/www/html/
