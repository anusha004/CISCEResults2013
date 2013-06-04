#!/bin/bash
res=`cat *.csv | grep -Eo ','$1',[[:digit:]]{1,3},' | tr -d ',' | sed -E 's/'$1'//g' | sort -n | uniq -c`
echo "$res" | awk '{print $2}' > tmp
echo "`seq 0 100`"  | grep -vxF -f tmp | awk '{print 0, $1}' > tmp2
echo "$res" > tmp3
sort -nk 2 tmp3 tmp2 
rm tmp3
rm tmp2
rm tmp
