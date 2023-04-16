#!/bin/bash

# What is Loop?

# If you want to run something for certain no. of times, we will use a loop

# There are 2 major types of loops :

#     1) For loop       ( When you know something to be executed n number of time, we use for loop)
#     2) While loop     ( When you don't know something to be executed n number of times, we use while loop)


# For Loop Syntax:

for val in -e "\e[33m 10 20 30 40 50 \e[0m" ; do 
    echo "value of a in the list is : $val "
done 

