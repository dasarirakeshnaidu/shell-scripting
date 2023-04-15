#!/bin/bash


# There are 4 types of command available : 

# 1) Binary                   ( /bin  , /sbin )
# 2) Aliases                  ( Alises are shortcuts,  alias net="netstat -tulpn" )
# 3) Shell Built-in Commands  ( type cd , type export , type cat , type vi)
# 4) Functions               
#  nothing but a set of command that can be written in a sequence and can be called n number of times


# Hw to declare a function?

sample() {
    echo "I am a message called from sample function"
}

# This is how we call a function.
 stat() {
    echo -e "\t Total number of sessons :\e[32m $(who | wc -l) \e[0m"
    echo "Today's date is $(date +%F)"
    echo "Load Average On The system is $(uptime | awk -F : '{print $NF}' | awk -F , '{print $1}')"
    echo -e "\t stat function completed"

    echo "Calling sample function"
    sample 
 }

 echo "calling stat function" 
 stat
