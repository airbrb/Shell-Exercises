#!/bin/bash
inputList=("$@")

for (( i=0; i <= 4; i++ ))
do
    echo "${inputList[i]}"
done