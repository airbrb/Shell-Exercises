#!/bin/bash
read -p "Enter 2 numbers separated by space: " numberInput
numbers=($numberInput)
sum=`expr ${numbers[0]} + ${numbers[1]}`
echo "${numbers[0]} + ${numbers[1]} = $sum"