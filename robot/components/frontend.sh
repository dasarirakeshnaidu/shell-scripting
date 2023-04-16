#!/bin/bash

set -e

yum install nginx -y

curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx
systemctl start nginx 

# restart nginx

# here there are 3 observations :
# 1) few of the steps are failed here but still my sript got executed : set -e
# 2) Installation  got failed because I've not validated that I've root privilages
# 3) The info i would like to provide is like success or failure