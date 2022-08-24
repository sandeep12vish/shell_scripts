#!/bin/bash
# Function example

myFunction(){

	echo 'Please enter any two number'
	printf "NUmber-1 :"
	read number1;
	printf 'Number-2 :'
	read number2;	
	sum=$(($number1 + $number2))
	echo 'Addition:'$sum 

}
#function call
# Accept number
sumNumber()
{
	echo 'please enter any 5 numbers :'
	sum=0
	for i in {0..5}
	 do
		read num 
	done

}

#myFunction

sumNumber
