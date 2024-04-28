#!/bin/bash
# Stopping existing node servers
echo "Stopping any existing node servers"
pkill node
# Starting node server
cd /var/www/html
npm install
nohup npm start > /dev/null 2>&1 &
