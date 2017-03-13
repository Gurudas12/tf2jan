#### Server config:

#LOCAL
namenode    = 'localhost'
webhdfsport = 50070
dtserver    = 'localhost'
sshuser     = 'hduser'	
sshkey      = '/home/hduser/.ssh/id_rsa'
dtinstall   = '/home/hduser/datatorrent/current/'

#CLUSTER
#namenode    = 'node34.morado.com'
#webhdfsport = 50070
#dtserver    = 'node35.morado.com'
#sshuser     = 'dttbc'
#sshkey      = '/root/.ssh/node30_id_rsa'
#dtinstall = '/home/dttbc/datatorrent/current/'

dtbin     = dtinstall + 'bin/'
dtcli     = dtbin + 'dtcli'
dtcli_log = '/tmp/dtcli.log'

#### Module info:
#pkg_mobile_demo       = dtinstall + 'demos/mobile-demo-3.2.0-incubating.apa'
#TC_CONFIG_DIR_PATH    = /home/pradeep/workspace/QA/framework/Tests/Modules/sample-module/sample-module-test-configs/

