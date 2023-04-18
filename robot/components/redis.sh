#!/bin/bash

COMPONENT=redis
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

echo -n "Configuring $COMPONENT repo :"

curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
stat?

echo -n "Installing $COMPONENT server :"
yum install redis-6.2.11 -y    &>>  $LOGFILE
stat $?

echo -n "Updating the $COMPONENT visibility : "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
stat $?

echo -n "Performing the Daemon-reload : "
systemctl daemon-reload   &>> $LOGFILE
systemctl restart $COMPONENT  &>> $LOGFILE
stat $?



