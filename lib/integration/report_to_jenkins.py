#!/usr/bin/python

import paramiko
from scp import SCPClient
import subprocess
import os

#os.system("scp -r /var/dt/tf/logs/260/* akshay@node5:/home/akshay/robot_logs")
#p = subprocess.Popen(["scp  ", "/var/dt/tf/logs/260/", "akshay@node5:/home/akshay/robot_logs"])
#sts = os.waitpid(p.pid, 0)

print os.popen("scp -r /var/dt/tf/logs/260/* akshay@node5:/home/akshay/robot_logs").read()


