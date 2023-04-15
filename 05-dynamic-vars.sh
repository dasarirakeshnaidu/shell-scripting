#!/bin/bash

TODAYDATE=$(date +%F)  # This way of declaring is called as hardcoding.

# to see no. of users logged in to the system $ who



echo -e "Welcome to Bash Training, Today date is \e[33m ${TODAYDATE} \e[0m"
echo -e "Number of users sessions in the system are : \e[36m  $(who | wc -l) \e[0m"


