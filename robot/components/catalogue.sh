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

id $APPUSER   &>> $LOGFILE
if [ $? -ne 0 ] ; then
      echo -n "Creating the Application User account : "
      useradd roboshop  &>> $LOGFILE
      stat $?
fi      

echo -n "Downloading the $COMPONENT component :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip" &>> $LOGFILE
stat $?

echo -n "Extracting the $COMPONENT in the $APPUSER directory : "
cd /home/$APPUSER
rm -rf /home/$APPUSER/$COMPONENT  &>> $LOGFILE
unzip -o /tmp/$COMPONENT.zip  &>> $LOGFILE
stat $?

echo -n "Configuring the permissions: "
mv /home/$APPUSER/$COMPONENT-main /home/$APPUSER/$COMPONENT
chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT
stat $?

echo -n "Installing the $COMPONENT Application : "
cd /home/$APPUSER/$COMPONENT/
npm install &>> $LOGFILE
stat $?


echo -n "Updating the systemd file with DB details : "
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' home/$APPUSER/$COMPONENT/systemd.service
mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
stat $?

echo -n "Starting the $COMPONENT service : "
systemctl daemon-reload    &>> $LOGFILE
systemctl start $COMPONENT  &>> $LOGFILE
systemctl enable $COMPONENT &>> $LOGFILE
stat $? 


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


