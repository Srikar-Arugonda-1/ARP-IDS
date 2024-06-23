#!/bin/sh

arpTable=`cat /proc/net/arp | cut -f 1,2,12-15,21-23 -s -d " "`
allMac=`cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d " " | awk '{print $1}'`

for mac in $allMac; do
  host=`cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d " " | grep $mac | awk '{print $3}'`
  ip=`cat /tmp/dhcp.leases | cut -f 2,3,4 -s -d " " | grep $mac | awk '{print $2}'`
  echo "debug"
  count=`echo -e $arpTable | grep $mac | wc -l`
  if [ $count -eq 0 ]; then
    echo -e "$ip\t$mac\t$host\tVICTIM" >> arptests.log
  elif [ $count -eq 1 ]; then
    continue
  else
    echo -e "$ip\t$mac\t$host\tATTACKER" && echo "Attacker detected" >> arptests.log
  fi
done
