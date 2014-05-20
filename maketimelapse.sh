#!/bin/bash
# This script will make a timelapse video of images contained in the DIR folder.
# This will require mencoder and avconv to be installed. as well as the extra codec packs for libavcodec

DIR=/mnt/data/timelapse

TODAY=`date +%m-%d-%y`

cd $DIR
ls -1tr | grep .jpg > $DIR/files.txt

mencoder -idx -nosound -noskip -ovc lavc -lavcopts vcodec=mjpeg -o timelapse.avi -mf fps=15 'mf://@files.txt' 

avconv -i timelapse.avi -c:v libx264 -crf 15 ./daily/$TODAY.mp4

mkdir ./daily/$TODAY
mv ./*.jpg ./daily/$TODAY/
rm files.txt timelapse.avi 
