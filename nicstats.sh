#!/bin/bash

if [ -z $1 ] 
then
	echo "please enter an argument availiable options are:"
	echo "auth active running blocked idle job user kill node help"
	echo "enter help for argument usage"
	exit 1
fi

if [ "$1" == "help" ]
then 
	echo "auth - will append the authorized keys file on the cluster with your public key, after running this you will no longer be prompted for your password."
	echo "active -shows current cluster usage."
	echo "running - shows currently running jobs on the cluster searchable via \"/\$searchterm\"." 
	echo "blocked - shows blocked jobs searchable."
	echo "idle - shows all idle jobs searchable."
	echo "job - ex. job \$jobid - displays the information on the job specified."
	echo "user - ex. user \$userid - displays the information on submitted jobs for current user."
	echo "kill - ex. kill \$jobid - displays the infomation on the job specified then asks if you are sure you want to kill it."
	echo "node - ex. node \$nodeid.local - opens a session as root on given node"
	echo "help - displays this message."
	exit 1
fi

# authorizes your machine to access the cluster and head node with public key authentication
if [ "$1" == "auth" ]
then 
cat ~/.ssh/id_rsa.pub | ssh nic.mst.edu 'cat >> ~/.ssh/authorized_keys'
cat ~/.ssh/id_rsa.pub | ssh nic-cluster.mst.edu 'cat >> ~/.ssh/authorized_keys'
exit 1
fi


# checks the activity of the cluster
if [ "$1" == "active" ]
then
ssh nic.mst.edu 'showq | grep %'
exit 1
fi

# shows the running jobs on the cluster
if [ "$1" == "running" ]
then
ssh -t nic.mst.edu 'showq -r | less'
exit 1
fi

# shows the idle jobs on the cluster
if [ "$1" == "idle" ]
then
ssh -t nic.mst.edu 'showq -i | less'
exit 1
fi

# shows the blocked jobs on the cluster
if [ "$1" == "blocked" ]
then 
ssh -t nic.mst.edu 'showq -b | less'
exit 1
fi

# shows information on a given jobid
if [ "$1" == "job" ]
then
if [ -z $2 ]
then
echo "please enter jobid:"
read jobid
else
jobid=$2
fi
echo ""
ssh nic.mst.edu "showq | grep REMAINING"
ssh nic.mst.edu "showq | grep $jobid"
echo ""
ssh nic.mst.edu "qstat $jobid"
echo ""
echo "node information"
ssh nic.mst.edu "pbsnodes | grep $jobid"
exit 1
fi

# shows job information on a given userid
if [ "$1" == "user" ] 
then
if [ -z $2 ]
then
echo "please enter userid:"
read userid
else
userid=$2
fi
ssh nic.mst.edu "showq -u $userid"
exit 1
fi

# kills a given jobid
if [ "$1" == "kill" ]
then
if [ -z $2]
then 
echo "please enter jobid:"
read jobid
else
jobid=$2
fi
ssh nic.mst.edu "qstat $jobid"
fi
echo "are you sure you want to kill this job? yes/no"
while [ "$answer" != "no" ]
do
read answer
if [ "$answer" == "yes" ]
then 
echo "please enter your sudo password when prompted"
ssh nic-cluster.mst.edu "sudo qdel -p $jobid"
echo "done"
exit 1
elif [ "$answer" == "no" ] 
then 
echo "ok I won't"
exit 1
else
echo "please enter \"yes\" or \"no\""
fi
done
fi

# opens a root session on a given node
if [ "$1" == "node" ]
then 
if [ -z $2]
then
echo "please enter nodeid.local:"
read nodeid
else
node=$2

ssh -t nic.mst.edu "sudo ssh -t $node"
fi
fi

exit 1

