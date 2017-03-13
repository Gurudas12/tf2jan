#### Server config:



#LOCAL
#dtserver    = 'localhost'
#sshuser     = 'yogi'
#sshkey      = '/home/yogi/.ssh/id_rsa'
#rep_path = '/home/yogi/rep/'

#CLUSTER
dtserver    = 'node35.morado.com'
sshuser     = 'appuser'
sshkey      = '/home/devendra/.ssh/id_rsa_appuser'
rep_path = '/home/devendra/rep/'

#dtserver    = 'node35.morado.com'
#sshuser     = 'dttbc'
#sshkey      = '/root/.ssh/node30_id_rsa'
#dtinstall = '/home/dttbc/datatorrent/current/'

dtbin     = rep_path + 'incubator-apex-core/engine/src/main/scripts/'
dtcli     = rep_path + 'incubator-apex-core/engine/src/main/scripts/'
dtinstall = dtbin
dtcli_log = '/tmp/dtcli.log'

#### Module info:
pkg_hdfs_sync   = rep_path + 'incubator-apex-malhar/apps/filecopy/target/filecopy-3.4.0-incubating-SNAPSHOT.apa'
TC_CONFIG_DIR_PATH    = rep_path + 'QA/framework/Tests/Solutions/HDFS-Sync/xmlConfigs-cluster'
DTCLI_APP_PATH        = 'datatorrent/apps/'
