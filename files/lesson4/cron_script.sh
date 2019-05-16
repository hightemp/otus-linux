#!/usr/bin/env bash

X=5
Y=5

sLOGFILE=access.log
sLOCKFILE=/var/tmp/cron_script.lock

if [ -f $sLOCKFILE ]; then
    echo "cron_script is running"
    exit 1
fi

touch $sLOCKFILE
trap 'rm -f "$sLOCKFILE"; exit $?' INT TERM ERR EXIT

#declare -A aIP
#declare -A aURL
aIP=()
aURL=()

sFROMDATE=""
sTODATE=""

while read LINE; do 
    if [[ "$sFROMDATE" == "" ]]; then
        sFROMDATE=`echo $LINE | awk '{print $4}' | sed 's/\[//'`
    fi
    sIP=`echo $LINE | awk '{print $1}'`
    aIP+=($sIP)
    sURL=`echo $LINE | awk '{print $7}'`
    aURL+=($sURL)
#     if [ ${aIP[$IP]+_} ]; then
#         (( $aIP["$IP"]++ ))
#     else
#         $aIP[$IP]=0
#     fi
done < $sLOGFILE

sTODATE=`tail -1 $sLOGFILE | awk '{print $4}' | sed 's/\[//'`

echo "REPORT"
echo "$sFROMDATE - $sTODATE"

echo "IP:"
printf '%s\n' "${aIP[@]}" | sort | uniq -c | sort -rn | head -n$X

echo "URL:"
printf '%s\n' "${aURL[@]}" | sort | uniq -c | sort -rn | head -n$Y


rm -f $sLOCKFILE
trap - INT TERM ERR EXIT
