import sys
sys.path.append("/var/dt/tf/etc/environments/")
from server import *

#dtcli related parameters:
dtinstall              = '/home/dttbc/datatorrent/current/'
dtbin                  = dtinstall + 'bin/'
dtcli_log              = '/tmp/operator-xyz.log'

#General info:
app_pkg                = '/home/dttbc/pi-demo-3.4.0.apa'
APPLICATION_NAME       = 'PiDemoAppData'
OPERATOR_NAME          = 'rand'

