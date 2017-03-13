#### Server config:

#LOCAL
dtserver    = 'localhost'
sshuser     = 'chinmay'
sshkey      = '/home/chinmay/.ssh/id_dsa'
dtinstall   = '/home/chinmay/src/repos/apex/engine/src/main/scripts/'

#CLUSTER
#dtserver    = 'node0.morado.com'
#sshuser     = 'chaitanya'
#sshkey      = '/home/appuser/.ssh/id_rsa'
#dtinstall   = '/home/chaitanya/repos/Apex/engine/src/main/scripts/'
#dtserver    = 'node35.morado.com'
#sshuser     = 'dttbc'
#sshkey      = '/root/.ssh/node30_id_rsa'
#dtinstall = '/home/dttbc/datatorrent/current/'

dtbin     = '/home/chinmay/src/repos/apex/engine/src/main/scripts/'
dtcli     = '/home/chinmay/src/repos/apex/engine/src/main/scripts/'
dtcli_log = '/tmp/dtcli.log'

#### Module info:
pkg_aggregation_app   = '/home/chinmay/src/repos/megh/demos/aggregation-module-app/target/aggregation-module-app-3.3.0-SNAPSHOT.apa'
TC_CONFIG_DIR_PATH    = '/home/chinmay/src/repos/QA/framework/Tests/Modules/aggregation-module/xmlConfigs'
DTCLI_APP_PATH        = 'datatorrent/apps/'
