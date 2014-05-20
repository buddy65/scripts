#!/bin/bash
if [ $# -eq 0 ]
then 
echo "usage auth.sh user@hostname port"
echo "this should ask you for your password twice"



#ssh $1 'mkdir -p ~/.ssh/ && touch ~/.ssh/authorized_keys'
#cat ~/.ssh/id_rsa.pub | ssh $1 -p $2 'cat >> ~/.ssh/authorized_keys'
#ssh -t $1 -p $2
else
ssh $1 'mkdir -p ~/.ssh/ && touch ~/.ssh/authorized_keys'
cat ~/.ssh/id_rsa.pub | ssh $1 'cat >> ~/.ssh/authorized_keys'
ssh -t $1 
fi
exit 1
