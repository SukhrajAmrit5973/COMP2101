#!/bin/bash

This is a script to practice doing testing in bash scripts
This section demonstrates file testing
Test for the existence of the /etc/resolv.conf file
TASK 1: Add a test to see if the /etc/resolv.conf file is a regular file
TASK 2: Add a test to see if the /etc/resolv.conf file is a symbolic link
TASK 3: Add a test to see if the /etc/resolv.conf file is a directory
TASK 4: Add a test to see if the /etc/resolv.conf file is readable
TASK 5: Add a test to see if the /etc/resolv.conf file is writable
TASK 6: Add a test to see if the /etc/resolv.conf file is executable
if [ -e /etc/resolv.conf ]; then
echo "/etc/resolv.conf exists"

if [ -f /etc/resolv.conf ]; then
echo "/etc/resolv.conf is a regular file"
fi

if [ -h /etc/resolv.conf ]; then
echo "/etc/resolv.conf is a symbolic link"
fi

if [ -d /etc/resolv.conf ]; then
echo "/etc/resolv.conf is a directory"
fi

if [ -r /etc/resolv.conf ]; then
echo "/etc/resolv.conf is readable"
fi

if [ -w /etc/resolv.conf ]; then
echo "/etc/resolv.conf is writable"
fi

if [ -x /etc/resolv.conf ]; then
echo "/etc/resolv.conf is executable"
fi

else
echo "/etc/resolv.conf does not exist"
fi

TASK 4: Add a test to see if the /tmp directory is readable
[ -r /tmp ] && echo "/tmp is readable" || echo "/tmp is not readable"

TASK 5: Add a test to see if the /tmp directory is writable
[ -w /tmp ] && echo "/tmp is writable" || echo "/tmp is not writable"

TASK 6: Add a test to see if the /tmp directory can be accessed
[ -x /tmp ] && echo "/tmp can be accessed" || echo "/tmp cannot be accessed"


TASK 7: Add testing to print out which file newest, or if they are the same age
if [ /etc/hosts -nt /etc/resolv.conf ]; then
echo "/etc/hosts is newer than /etc/resolv.conf"
elif [ /etc/hosts -ot /etc/resolv.conf ]; then
echo "/etc/resolv.conf is newer than /etc/hosts"
else
echo "/etc/hosts is the same age as /etc/resolv.conf"
fi


TASK 1: Improve it by getting the user to give us the numbers to use in our tests
read -p "Enter the first number: " firstNumber
read -p "Enter the second number: " secondNumber

TASK 2: Improve it by adding a test to tell the user if the numbers are even or odd
if [ $((firstNumber % 2)) -eq 0 ]; then
echo "The first number is even"
else
echo "The first number is odd"
fi

if [ $((secondNumber % 2)) -eq 0 ]; then
echo "The second number is even"
else
echo "The second number is odd"
fi

TASK 3: Improve it by adding a test to tell the user is the second number is a multiple of the first number
if [ $((secondNumber % firstNumber)) -eq 0 ]; then
echo "The second number is a multiple of the first number"
else
echo "The second number is not a multiple of the first number"
fi

[ $firstNumber -eq $secondNumber ] && echo "The two numbers are the same"
[ $firstNumber -ne $secondNumber ] && echo "The two numbers are not the same"
[ $firstNumber -lt $secondNumber ] && echo "The first number is less than the second number"
[ $firstNumber -gt $secondNumber ] && echo "The first number is greater than the second number"

[ $firstNumber -le $secondNumber ] && echo "The first number is less than or equal to the second number"
[ $firstNumber -ge $secondNumber ] && echo "The first number is greater than or equal to the second number"



TASK 1
if [ -n "$USER" ]; then
echo "The USER variable contains: $USER"
fi

TASK 2
if [ ! -n "$USER" ]; then
echo "The USER variable exists, but is empty"
fi

TASK 3
if [ "$a" != "$b" ]; then
echo "$a is not alphanumerically equal to $b"
else
echo "$a is alphanumerically equal to $b"
fi

TASK 4
echo "Please enter the first string:"
read string1
echo "Please enter the second string:"
read string2

if [ "$string1" != "$string2" ]; then
echo "$string1 is not alphanumerically equal to $string2"
else
echo "$string1 is alphanumerically equal to $string2"
fi




