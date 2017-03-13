#!/bin/bash
#Mon Jun 29 12:49:12 UTC 2015

#nohup python /usr/local/lib/python2.7/dist-packages/nosier2/nosier.py -p /var/dt/tf/tmp/bugzilla/ -a  'ls -la ' -r >> /var/log/nosier.log &
nohup python /var/dt/tf/lib/integration/nosier.py -p /var/dt/tf/tmp/bugzilla/ -a  'ls -la ' -r >> /var/log/nosier.log &
cd /tmp/
nohup mlaunch --sleep 10 --nlaunches infinite --loglvl DEBUG 5 >> /var/log/mlaunch.log &
nohup lpad webgui  -s --host 192.168.2.209 >> /var/log/lpad/lpad.log &

