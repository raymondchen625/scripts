#!/bin/bash
# Run this on server side to listen: for i in {start..end}; do nc -lv $i & ;done
# And run this to probe those ports one by one
[ -z "$1" ] || [ -z "$2" ]  && (echo "usage: port-probe.sh HOST PORT-RANGE"; exit 1)
start=`echo $2 | cut -d"-" -f1`
end=`echo $2 | cut -d"-" -f2`
for port in `seq $start $end`; do
  printf "GET / HTTP/1.0\r\n\r\n" | nc $1 $port
  if [ ! "$?" = 0 ]; then
		echo "Port $port probe failed."
	fi
done
