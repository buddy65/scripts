#!/bin/bash

#this script will grab stuff given a youtube link

if [ -z $1 ]
then
	echo "useage \"tube.sh http://blah.blah\" trail it with an & to background it."

else
	/usr/bin/youtube-dl -cit --max-quality H264 $1 
fi
