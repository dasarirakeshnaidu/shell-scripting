#!/bin/bash

set -e

# validating whether the executed user is root user or not
ID=$(id -u)

if [ "$ID" -ne 0 ] ; then
    echo -e "\e[31m You should execute this script as a root user or with a sudo as prefix \e[0m"
    exit 1
fi

echo "Installing Nginx : "
yum install nginx -y &>> /tmp/frontend.log

if[ $? -eq 0 ] ; then
     echo -e "\e[32m Success \e[0m"
else 
     echo -e "\e[31m Failure \e[0m"
fi
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

cd /usr/share/nginx/html
rm -rf *   &>> /tmp/frontend.log
unzip /tmp/frontend.zip  &>> /tmp/frontend.log
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl enable nginx  &>> /tmp/frontend.log
systemctl start nginx   &>> /tmp/frontend.log

# restart nginx

# here there are 3 observations :
# 1) few of the steps are failed here but still my sript got executed : set -e
# 2) Installation  got failed because I've not validated that I've root privilages
# 3) The info i would like to provide is like success or failure