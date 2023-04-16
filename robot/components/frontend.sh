#!/bin/bash

# set -e
COMPONENT=frontend
LOGFILE="/tmp/$COMPONENT.log"

# validating whether the executed user is root user or not
ID=$(id -u)

if [ "$ID" -ne 0 ] ; then
    echo -e "\e[31m You should execute this script as a root user or with a sudo as prefix \e[0m"
    exit 1
fi

stat() {
    if [ $1 -eq 0 ] ; then
         echo -e "\e[32m success \e[0m"
    else 
         echo -e "\e[31m Failure \e[0m"
    exit 2
    fi
}

echo -n "Installing Nginx : "
yum install nginx -y &>> $LOGFILE
stat $?

echo -n "Downloading the $COMPONENT component :"

curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

echo -n "Performing cleanup of old $COMPONENT content :"

cd /usr/share/nginx/html
rm -rf *   &>> $LOGFILE
stat $?

echo -n "Copying the downloaded $COMPONENT content : "

unzip /tmp/$COMPONENT.zip  &>> $LOGFILE
mv $COMPONENT-main/* .
mv static/* .
rm -rf $COMPONENT-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "Starting the service: "

systemctl enable nginx  &>> $LOGFILE
systemctl start nginx   &>> $LOGFILE
stat $?


# restart nginx

# here there are 3 observations :
# 1) few of the steps are failed here but still my sript got executed : set -e
# 2) Installation  got failed because I've not validated that I've root privilages
# 3) The info i would like to provide is like success or failure