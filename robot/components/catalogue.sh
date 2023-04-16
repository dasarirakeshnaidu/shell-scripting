#!/bin/bash

# set -e
COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"
APPUSER=roboshop

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

echo -n "Configuring the nodejs repo : "
curl --silent --location https://rpm.nodesource.com/setup_16.x | bash -  &>> $LOGFILE
stat $?

echo -n "Installing NodeJS : "
yum install nodejs -y  &>> $LOGFILE
stat $?

echo -n "Creating the Application User account : "
useradd roboshop  &>> $LOGFILE
stat $?

echo -n "Downloading the $COMPONENT component :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

echo -n "Extracting the $COMPONENT in the $APPUSER directory"
cd /home/roboshop
unzip -o /tmp/$COMPONENT.zip  &>> $LOGFILE


# $ curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
# $ cd /home/roboshop
# $ unzip /tmp/catalogue.zip
# $ mv catalogue-main catalogue
# $ cd /home/roboshop/catalogue
# $ npm install

# ```

# 1. Update SystemD file with correct IP addresses
    
#     Update `MONGO_DNSNAME` with MongoDB Server IP
    
#     ```sql
#     $ vim systemd.servce
#     ```
    
# 2. Now, lets set up the service with systemctl.

# ```bash
# # mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# # systemctl daemon-reload
# # systemctl start catalogue
# # systemctl enable catalogue
# # systemctl status catalogue -l

# **NOTE:** You should see the log saying `connected to MongoDB`, then only your catalogue
# will work and can fetch the items from MongoDB

# **Ref Log:**
# {"level":"info","time":1656660782066,"pid":12217,"hostname":"ip-172-31-13-123.ec2.internal","msg":**"MongoDB connected",**"v":1}
# ```

# 1. Now, you would still see **`CATEGORIES`** on the frontend page as empty. 
# 2. That’s because your `frontend` doesn't know who the `CATALOGUE` is when someone clicks the `CATEGORIES` option. So, we need to update the Nginx Reverse Proxy on the frontend. If not, you’d still see the frontend without categories.

# ![empty-catalogue.JPG](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/af5a2425-8a4a-4001-8404-8f05c5f79f90/empty-catalogue.jpg)

# 1. In order to make it work, update the proxy file in Nginx with the `CATALOGUE` server IP Address in the **`FRONTEND`** Server  

# **`Note:`** Do not do a copy and paster of IP in the proxy file, there are high chances to enter the empty space characters, which are not visible on the vim editor. Manual Typing of IP Address/ DNS Name is preferred. 

# > # vim /etc/nginx/default.d/roboshop.conf
# > 

# 1. Reload and restart the Nginx service.

# > # systemctl restart nginx
# > 

# 1. Now you should be able to see the categories on the frontend page.

# ![categories.JPG](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/9a72f438-4132-4270-b057-c6ef01108061/categories.jpg)

# 1. This completes the `CATALOGUE` component. ( Now move to the next component `REDIS`)
# echo -n "Configuring the $COMPONENT repo :"

# curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
# stat $?


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

echo -n "Extracting the $COMPONENT schema : "
unzip  -o /tmp/$COMPONENT.zip  &>> $LOGFILE
stat $?

echo -n "Injecting the schema :"
cd /tmp/$COMPONENT-main
mongo < catalogue.js   &>> $LOGFILE
mongo < users.js       &>> $LOGFILE
stat $