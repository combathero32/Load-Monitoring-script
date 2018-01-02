#!/bin/bash

trigger=1.00
load=`cat /proc/loadavg | awk '{print $3}'`
response=`echo | awk -v T=$trigger -v L=$load 'BEGIN{if ( L > T){ print "greater"}}'`
if [[ $response = "greater" ]]
then
echo "To:email@email.com" > /etc/cron.d/smtpmsg.txt
echo "From:email@email.com" >> /etc/cron.d/smtpmsg.txt
echo "Subject:Cron Alert Message (server Load Average: Warning above 1.00)" >> /etc/cron.d/smtpmsg.txt
echo "" >> /etc/cron.d/smtpmsg.txt
uptime >> /etc/cron.d/smtpmsg.txt
echo "" >> /etc/cron.d/smtpmsg.txt
ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10 >> /etc/cron.d/smtpmsg.txt
echo "" >> /etc/cron.d/smtpmsg.txt
free >> /etc/cron.d/smtpmsg.txt
echo "" >> /etc/cron.d/smtpmsg.txt
smartctl -A /dev/sda >> /etc/cron.d/smtpmsg.txt
/usr/sbin/ssmtp email@email.com < /etc/cron.d/smtpmsg.txt
fi
