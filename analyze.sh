#!/bin/sh

trap "rm -f /tmp/analyze-$$-*" INT TERM EXIT

for id in `grep "# User" $1 | sed -e "s/.*Id: \([0-9]*\)$/\1/g" | sort | uniq -c | sort -r | sed -e "s/  */ /g" | cut -d" " -f3`;
do
    TEMP=`mktemp /tmp/analyze-$$-XXXXX`
    grep -A3 $id $1 | grep -v "\-\-" > ${TEMP}
    mysqldumpslow -s c $TEMP > ./slow.log.${id}
done
