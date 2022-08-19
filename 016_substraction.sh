#!/bin/bash

echo "Please enter first number :"
read num1;
echo "Please enter second number: "
read num2;

printf "You entered: %d and %d\n" $num1 $num2
printf "Difference: %d\n" $(( num1 - num2))


