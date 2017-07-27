#!/bin/bash

#export DIR="/root/accessibility/log"
#mkdir -p $DIR
#echo "Script is executed." >$DIR/out.txt
#echo `google-chrome --version` >>$DIR/out.txt
#echo `dpkg -l | grep -E '^ii' | grep xvfb` >>$DIR/out.txt
echo "Starting Xvfb Process."
`Xvfb :0 -screen 0 1024x768x16 &`

echo "*********************** MAVEN TEST STARTED ****************************"
echo "Wait for few minutes for the process to complete ..."
mvn  test > /dev/null 2>&1
echo "************************ MAVEN TEST END *******************************"
