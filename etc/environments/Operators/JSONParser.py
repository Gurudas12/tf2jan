import sys
sys.path.append("/var/dt/tf/etc/environments/")
sys.path.append("/home/pradeep/workspace/QA/framework/etc/environments/")
from server import *

#dtcli related parameters:
dtinstall              = '/home/dttbc/datatorrent/current/'
dtinstall              = '/home/hduser/datatorrent/current/'
dtbin                  = dtinstall + 'bin/'
dtcli_log              = '/tmp/json-parser-xyz.log'

#General info:
app_pkg                = '/home/dttbc/parser-1.0-SNAPSHOT.apa'
app_pkg                = '/home/pradeep/workspace/datatorrent/examples/tutorials/parser/target/parser-1.0-SNAPSHOT.apa'
APPLICATION_NAME       = 'JsonProcessor'
OPERATOR_NAME          = 'JsonParser'
numTuples              = 271
INPUT_OP_NAME          = 'JsonGenerator'    #For testing dynamic scalability
INPUT_OP_PROP_NAME     = 'numTuples'        #Name of the property which controls the throughout
INPUT_OP_PROP_VALUE    = 3000               #Value of the property which controls the throughout above which partions change
