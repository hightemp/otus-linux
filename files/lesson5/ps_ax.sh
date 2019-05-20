#!/usr/bin/env bash

iMAX_LIST_LENGTH=1000

while [[ $# -gt 0 ]]; do
	case $1 in
		-n)
			iMAX_LIST_LENGTH=$2
			shift
			shift
		;;
	esac
done

iCounter=0

sFormat='%5s %-9s%-7s%5s %-100s\n'

printf "$sFormat" PID TTY STAT TIME COMMAND

for sProccessDir in `ls /proc | sort -V`; do
	if [[ $iCounter -gt iMAX_LIST_LENGTH ]]; then
		continue
	fi

	if [[ $sProccessDir =~ ([0-9]+) ]]; then
		iPID=${BASH_REMATCH[1]}
		
		sProcStat=`cat /proc/$iPID/stat`

		sProcState=`echo "$sProcStat" | awk '{print $3}'`
		sProcTTY=`echo "$sProcStat" | awk '{print $7}'`
		sProcStartTime=`echo "$sProcStat" | awk '{print $22}'`
		sProcCommand=`cat /proc/$iPID/cmdline | sed -E 's/[\x0\n]//g'`

		if [ "$sProcCommand" == "" ]; then
			sProcCommand="[";
			sProcCommand+=`cat /proc/$iPID/stat | awk '{print $2}' | sed 's/[\(\)]//g'`
			sProcCommand+="]"
		fi

		d=$((sProcStartTime/60/60/24))
    	h=$((sProcStartTime/60/60%24))
    	m=$((sProcStartTime/60%60))
    	s=$((sProcStartTime%60))
		
		sTime=""
		
		if [[ $d > 0 ]]; then
			sTime+="$d "
		fi

		if [[ $h > 0 ]]; then
			sTime+="$h "
		fi

		sTime=`printf "%02d:%02d" $m $s`

		printf "$sFormat" "$iPID" "$sProcTTY" "$sProcState" "$sTime" "$sProcCommand"
	fi

	(( iCounter++ ))
done
