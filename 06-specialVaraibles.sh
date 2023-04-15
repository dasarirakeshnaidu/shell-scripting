#!/bin/bash

# Special Characters :  $0 to $9 , $* , $# , #@ , $$   
a=10

echo "Value of a is $a"

echo "Name of the script is : $0"     # Gives the name of the script you're running  

echo first value is $1
echo second value is $2 
echo third value is $3

# bash scriptName.sh 100 200 300

# echo $* : going to print the used variables
# echo $@ : going to print the used variables
# echo $$ : going to print the PID of current process 
# echo $# : going to print the total no. of arguments
# echo $? : going to print the exit code of last command

