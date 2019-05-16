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
aHTTP_CODE=()
aERROR=()

sFROMDATE=""
sTODATE=""

while read sLINE; do 
    if [[ "$sFROMDATE" == "" ]]; then
        sFROMDATE=`echo $sLINE | awk '{print $4}' | sed 's/\[//'`
    fi
    
    sIP=`echo $sLINE | awk '{print $1}'`
    aIP+=($sIP)
    
    sURL=`echo $sLINE | awk '{print $7}'`
    aURL+=($sURL)
    
    sHTTP_CODE=`echo $sLINE | awk '{print $9}'`
    
    if [[ "$sHTTP_CODE" =~ ^[1-5][0-9][0-9]$ ]]; then
        aHTTP_CODE+=($sHTTP_CODE)

        [[ "$sHTTP_CODE" -ge 500 ]] && aERROR+=("$sLINE")
    fi
done < $sLOGFILE

sTODATE=`tail -1 $sLOGFILE | awk '{print $4}' | sed 's/\[//'`

echo "REPORT"
echo "$sFROMDATE - $sTODATE"
echo ""
echo "IP:"
printf '%s\n' "${aIP[@]}" | sort | uniq -c | sort -rn | head -n$X
echo ""
echo "URL:"
printf '%s\n' "${aURL[@]}" | sort | uniq -c | sort -rn | head -n$Y
echo ""
echo "HTTP Statuses:"
printf '%s\n' "${aHTTP_CODE[@]}" | sort | uniq -c | sort -rn
echo ""
echo "Errors:"
printf '%s\n' "${aERROR[@]}"

rm -f $sLOCKFILE
trap - INT TERM ERR EXIT
