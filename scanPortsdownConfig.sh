#!/bin/bash

# This script is intended only for DATV Portsdown 2020 from BATC
# equipment with GPIO interface board and using a DC1OP mini IQ module.
# It provides automatic switching between SR 2000 or SR 4000 on mini IQ
# depending on the choice made on the touch screen.
#
#----------------------------------------------------
#           Version history
# May 23 2022: V0.0 first edition
# May 25 2022: V0.1 added output state for other SRs
#----------------------------------------------------
#
# SR2000 	-> GPIO18/Pin12 goes LOW
# SR4000 	-> GPIO18/Pin12 goes HIGH
# Other SR 	-> GPIO18/Pin12 goes LOW

# GPIO18/Pin12 couldn't be used for any other purpose
# Be careful to this situation in case of update your
# Portsdown equipment.

# BCM identification of Pin12
sr_select=18
# GPIO as output
gpio -g mode $sr_select output

# Logical states
low=0
high=1

# Path to Portsdown configuration file
FILE=/home/pi/rpidatv/scripts/portsdown_config.txt

# Get time of last modification
# in epoch format
OLDFILETIME=$(stat $FILE -c %Y)

# By starting this script update output
# Find the Symbol Rate line in file
stringFound=$(grep -i "symbolrate=" $FILE)

# Extract the current value
value=$(echo $stringFound | cut -d "=" -f2)
case $value in

2000)
gpio -g write $sr_select $low
;;

4000)
gpio -g write $sr_select $high
;;

*)
gpio -g write $sr_select $low
;;
esac

# Loop to detect a new modification time of file
while true
do
NEWFILETIME=$(stat $FILE -c %Y)

# if true
if [ $NEWFILETIME -ne $OLDFILETIME ]; then
OLDFILETIME=$NEWFILETIME

# Find the Symbol Rate line in file
stringFound=$(grep -i "symbolrate=" $FILE)

# Extract the current value
value=$(echo  $stringFound | cut -d "=" -f2)
case $value in

2000)
gpio -g write $sr_select $low
;;

4000)
gpio -g write $sr_select $high
;;

*)
gpio -g write $sr_select $low
;;
esac
fi

# Wait a little and loop
sleep .25
done

