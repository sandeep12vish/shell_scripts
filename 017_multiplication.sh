#!/bin/bash

echo "Please enter 1st number:"
read num1;
echo "Please enter 2nd number :"
read num2;

printf "two numbers are %d and %d \n" $num1 $num2
printf "multiplication:%d \n" $((num1*num2))

