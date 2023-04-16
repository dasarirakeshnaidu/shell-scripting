#!/bin/bash

# set -e
COMPONENT=mongodb
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

echo -n "Configuring the $COMPONENT repo :"

curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
stat $?


echo -n "Installing $COMPONENT :"

yum install -y mongodb-org &>> $LOGFILE
stat $?


echo -n "Starting $COMPONENT :"
systemctl enable mongod &>> $LOGFILE
systemctl start mongod  &>> $LOGFILE
stat $? 

echo -n "Updating the $COMPONENT visibility : "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?

echo -n "Performing the Daemon-reload : "
systemctl daemon-reload   &>> $LOGFILE
systemctl restart mongod  
stat $?

echo -n "Downloading the $COMPONENT schema :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

echo -n "Extracting the $COMPONENT schema :"
cd /tmp
unzip $COMPONENT.zip  &>> $LOGFILE
stat $?

echo -n "Injecting the schema :"
cd /tmp/$COMPONENT-main
mongo < catalogue.js   &>> $LOGFILE
mongo < users.js       &>> $LOGFILE
stst $?

# # cd /tmp
# # unzip mongodb.zip
# # cd mongodb-main
# # mongo < catalogue.js
# # mongo < users.js
# ```

# Symbol `<` will take the input from a file and give that input to the command.

# - Now proceed with the next component `CATALOGUE`



