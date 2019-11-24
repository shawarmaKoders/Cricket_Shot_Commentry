#!/usr/bin/env bash

source venv/bin/activate python pick_frames.py straight/straight20.mp4 
a=1
# -lt is less than operator
  
#Iterate the loop until a less than 10 
while [ $a -lt 14 ] 
do 
    # Print the values 
    echo $a
python pick_frames.py straight/straight$a.mp4
      
    # increment the value 
    a=`expr $a + 1` 
done 
