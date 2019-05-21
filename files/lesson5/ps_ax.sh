#!/usr/bin/env bash

iMAX_LIST_LENGTH=1000

while [[ $# -gt 0 ]]; do
	case $1 in
		-n)
			iMAX_LIST_LENGTH=$2
			shift
			shift
		;;
		*)
			echo "Wrong arguments"
			exit 1
		;;
	esac
done

iCounter=0

sFormat='%5s %-9s%-7s%8s %-100s\n'

printf "$sFormat" PID TTY STAT TIME COMMAND

for sProccessDir in `ls /proc | egrep '^[0-9]' | sort -V`; do
	if [ ! -d "/proc/$sProccessDir" ]; then
		continue
	fi

	if [[ $iCounter -gt iMAX_LIST_LENGTH ]]; then
		continue
	fi

	if [[ $sProccessDir =~ ([0-9]+) ]]; then
		iPID=${BASH_REMATCH[1]}
		
		sProcStat=`cat /proc/$iPID/stat`
		sProcState=`echo "$sProcStat" | awk '{print $3}'`
		sProcTTY=`echo "$sProcStat" | awk '{print $7}'`
		sProcUTime=`echo "$sProcStat" | awk '{print $14}'`
		sProcSTime=`echo "$sProcStat" | awk '{print $15}'`
		sProcCommand=`cat /proc/$iPID/cmdline | sed -E 's/[\x0\n]/ /g'`
		sProcPriority=`echo "$sProcStat" | awk '{print $18}'`
		sProcRSS=`echo "$sProcStat" | awk '{print $24}'`
		sProcStatus=`cat /proc/$iPID/status`

		sProcTTYName='?'

		if [ $sProcTTY -gt 0 ]; then
			iMAJOR=$(( ($sProcTTY >> 8) & 0xfff ))
			iMINOR=$(( ($sProcTTY & 0xff) | ($sProcTTY & 0xfff00000) >> 12 ))

			case $iMAJOR in
				3)
					if [ $iMINOR -lt 255 ]; then
						sString0="pqrstuvwxyzabcde"
						sString1="0123456789abcdef"
						iTmpMin0=$(( $iMINOR >> 4 ))
						iTmpMin1=$(( $iMINOR & 0x0f ))
						sT0="${sString0[$iTmpMin0]}"
						sT1="${sString1[$iTmpMin1]}"

						sProcTTYName=`printf "/dev/tty%c%c" $sT0 $sT1`
					fi
				;;
			esac
		fi

		sVmLock=0

		if [[ $sProcStatus =~ VmLck:[[:space:]]+([0-9]+) ]]; then
			sVmLock=${BASH_REMATCH[1]}
			if [ $sVmLock -gt 0 ]; then
				sProcState+="L"
			fi
		fi

		if [ "$sProcPriority" -lt 0 ]; then
			sProcState+="<"
		fi
		
		if [ "$sProcPriority" -gt 0 ]; then
			sProcState+="N"
		fi

		if [ "$sProcRss" == "0" -a "$sProcStat" != 'Z' ]; then
			sProcState+="W"
		fi

		if [ "$sProcCommand" == "" ]; then
			sProcCommand="[";
			sProcCommand+=`cat /proc/$iPID/stat | awk '{print $2}' | sed 's/[\(\)]//g'`
			sProcCommand+="]"
		fi

		iClockTicks=$(getconf CLK_TCK)

		(( sProcTime=$sProcUTime+$sProcSTime/$iClockTicks ))
		
		(( ss=$sProcTime%60 ))
		(( sProcTime/=60 ))
		(( mm=$sProcTime%60 ))
		(( sProcTime/=60 ))
		(( hh=$sProcTime%60 ))
		(( sProcTime/=60 ))
		(( dd=$sProcTime%60 ))
		(( sProcTime/=60 ))

		sTime=""
		
		if [[ $dd > 0 ]]; then
			sTime+="$d-"
		fi

		sTime=`printf "%02u:%02u:%02u" $hh $mm $ss`

		printf "$sFormat" "$iPID" "$sProcTTYName" "$sProcState" "$sTime" "$sProcCommand"
	fi

	(( iCounter++ ))
done
