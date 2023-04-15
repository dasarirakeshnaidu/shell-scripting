#!/bin/bash

# What is a variable??
#  which holds the value dynamically

a=10
b=20
c=30

# No datatypes are available in bash by default

# Everything is considered as String

# How do you print a variable ??

# We use a special character called $ to print

# echo $a or echo $(a) or echo "$a"


echo $a 
echo ${b} 
echo "$c"

echo "I am printing the value of d $d"

# When you try to print a variable which is not declared, bash is going to consider that as Null or empty

# rm -rf /data/${DATA_DIR}   # /data/test  ---> rm -rf /data/

# How do you supply variables from the command line 
# export varName =  value 