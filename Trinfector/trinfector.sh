#!/bin/bash

infector=`basename $0`

USAGE_VAR="Usage: ./$infector [target username] [target hostname] [script] [cycles]."

if [ ! $# -eq 4 -a ! $# -eq 5 ];
then
  echo $USAGE_VAR
  exit 1
fi

args=("$@")

target=${args[0]}
target_hostname=${args[1]}
script=${args[2]}
cycles=${args[3]}
local_hostname=`uname -n`

if [ "$target_hostname" != "$local_hostname" ];
then
  full_hostname=$target_hostname'.cs.trincoll.edu'
#  echo $infector
  infector_path=`pwd`
#  echo $infector_path
  echo "SSH-ing into $target_hostname ..."
  sleep 1
  ssh $full_hostname -t "cd $infector_path; ./$infector $target $target_hostname $script $cycles 1;"
  exit 1
else
  if [ $# -eq 5 ];
  then 
    if [ ${args[4]} -eq 1 ];
    then
      echo "Connected to $target_hostname."
    fi
  else
    echo "Already connected to $target_hostname."
  fi
fi

online=`who`

if [[ $online =~ $target ]]
then
  echo "The target $target is currently online on $target_hostname."
else
  echo "The target $target is not currently online! Try again later."
  exit 1
fi

echo "Starting script $script on target $target ..."
for (( i=0; i<$cycles; i++ ))
do
  sleep 1
  echo "Running iteration $i ..."
  sessions=`who | grep $target | grep -o 'pts/[0-9]'`
  for sess_id in $sessions;
  do  
    `./$script | write $target $sess_id &`
  done
done
echo "Ended script $script run for $cycles iterations."

echo "Exiting $infector script ..."
sleep 1
