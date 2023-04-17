#!/bin/bash

COMPONENT=redis


echo -n "Configuring the $COMPONENT repo : "
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>> $LOGFILE
stat $? 

echo -n "Installing $COMPONENT server :"
yum install redis-6.2.11 -y  &>> $LOGFILE
stat $? 

