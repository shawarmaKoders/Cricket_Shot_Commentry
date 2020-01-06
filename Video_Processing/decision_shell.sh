#!/usr/bin/env bash
source venv/bin/activate
a=1  
# -lt is less than operator 
  
#Iterate the loop until a less than 10 
while [ $a -lt 32 ] 
do 
    # Print the values 
    echo $a
python decision_maker.py straight$a.csv
      
    # increment the value 
    a=`expr $a + 1` 
done
