#!/bin/bash

export DISPLAY=:0
export DIR="/root/accessibility/log"
mkdir -p $DIR
rm -rf ${DIR}/out.txt
echo "Script is executed." >$DIR/out.txt
echo `google-chrome --version` >>$DIR/out.txt
echo `dpkg -l | grep -E '^ii' | grep xvfb` >>$DIR/out.txt
`Xvfb :0 -screen 0 1024x768x16 &`
echo "After the process run" >>$DIR/out.txt
echo `ps -ef| grep Xvfb` >>$DIR/out.txt
