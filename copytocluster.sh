#!/bin/bash

usage="usage: $(basename "$0") -s {sourcefilename} -d {destinationpath} -p [port] -u [username] -h {nodename}"
port=22
username="$USER"

if [ "$*" == "" ]; then
	printf "\n\n"
	echo "$usage"
	printf "\n\n"
	exit 1
fi

while test $# -gt 0;do
	case "$1" in
	-s)	shift
		s_file=$1
		shift
		;;
	-d)	shift
		d_path=$1
		shift
		;;
	-p)	shift
		port=$1
		shift
		;;
	-u)	shift
		username=$1
		shift
		;;
	-h)	shift
		nodename=$1
		shift
		;;
	-*)	printf "illegal option: -%s\n" >&2 
		echo "$usage"
		exit 1
		;;
	esac
	done

count=0
filename="$(basename $s_file)"
echo "$filename"

while IFS= read -r node;do
	if ssh -p $port $username@$node [ -f "$d_path/$filename" ];
		then
			ssh $node -p $port mv $d_path/$filename $d_path/backup.bak &
	fi
#	echo "$username"
	scp -P $port $s_file $username@$node:$d_path
	count=`expr $count + 1`
	printf "\n\n"
	echo "$s_file"
	echo "$d_path"	
	done<"$nodename"

while [ $count -gt 0 ];do
	wait $pids
	count=`expr $count - 1`
	done

