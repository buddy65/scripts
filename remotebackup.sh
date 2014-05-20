#!/bin/bash
# This script will connect to a remote machine and backup the specified folders on the fill in the variables below to do what you want. Requires SSH Key authentication to work silently otherwise it will ask for your password on the remote machine when it runs.

# Sets the variable to echo the date for logging
TODAY=`date +%F`
# Sets the log file
logfile=/var/log/backups/backup-$TODAY.log
# sets the port for ssh tunneling
port=10025
# sets the username on the remote machine
user=buddy
# FQDN for remote machine
machine=masterwebhome.myftp.org
# Folder on remote machine you want to back up
folders=/mnt/data/pictures/
# Where you want to back them up to locally
backuplocation=/mnt/data/pictures.backup/
# How long you want the script to run before it is killed in minutes
waittime=240

if [ -z $1 ]
then
echo "$TODAY"

rsync -avzrpi --partial --fuzzy --backup --suffix=backup.$TODAY --backup-dir=$backuplocation/old -e "ssh -p $port" $user@$machine:$folders $backuplocation >>$logfile 
PID2=$!
count=0
# enters a loop to kill the rsync job if it runs to long
while kill -0 $PID2 2> /dev/null
do
sleep 60
((count++))
if [ $count -gt $waittime ] ; then
kill -TERM $PID2 2> /dev/null
break
fi
done
wait ${PID2}
fi

if [ "$1" == "--dry-run" ]

then 
rsync -avzri --fuzzy --backup --suffix=backup$TODAY $1 -e "ssh -p $port" $user@$machine:$folders $backuplocation
fi
