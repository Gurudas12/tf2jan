import sys
sys.path.append("/var/dt/tf/etc/environments/")
#sys.path.append("/home/pradeep/workspace/QA/framework/etc/environments/")
from server import *

#dtcli related parameters: +++++++++++++++++++++++++++++++++++++++++++++++++++++
dtinstall              = '/home/dttbc/datatorrent/current/'
#dtinstall              = '/home/hduser/datatorrent/current/'
dtbin                  = dtinstall + 'bin/'
dtcli_log              = '/tmp/JDBCPollInuptOperator-robot.log'

#General info: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
app_pkg                = '/home/dttbc/test-apps/jdbcpoll_jdbc-1.0-SNAPSHOT.apa'
#app_pkg                = '/tmp/table-to-table-1.0-SNAPSHOT.apa'
APP_NAME               = 'jdbcpoll_jdbc'
OP_NAME                = 'JdbcInput'

#MySQL: ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
uname = 'root'
pswd = 'root@123'
#pswd = 'root123'
host = 'node35.morado.com'
#host = 'localhostQ'

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


