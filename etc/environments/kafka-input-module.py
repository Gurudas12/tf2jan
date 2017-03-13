#### Server config:

#dtserver    = 'localhost'
#dtserver    = 'node0.morado.com'
dtserver    = 'node35.morado.com'

#sshuser     = 'hduser'
#sshuser     = 'chaitanya'
sshuser     = 'dttbc'

#sshkey      = '/home/hduser/.ssh/id_rsa'
#sshkey      = '/home/chaitanya/.ssh/id_rsa'
#sshkey      = '/home/appuser/.ssh/id_rsa'
sshkey      = '/root/.ssh/node30_id_rsa'

#dtinstall   = '/home/pradeep/workspace/datatorrent/Apex/engine/src/main/scripts/'
#dtinstall   = '/home/chaitanya/repos/Apex/engine/src/main/scripts/'
#dtinstall   = '/home/dttbc/datatorrent/current/'
dtinstall   = '/home/dttbc/module/incubator-apex-core/engine/src/main/scripts/'

#dtbin      = '/home/pradeep/workspace/datatorrent/Apex/engine/src/main/scripts/'
#dtbin     = '/home/chaitanya/malhar/Apex/engine/src/main/scripts/'
#dtbin     = dtinstall + '/bin'
dtbin      = '/home/dttbc/module/incubator-apex-core/engine/src/main/scripts/'

module_logs = '/tmp/kafka-input-module.log'

#namenode    = 'localhost'
namenode    = 'node34.morado.com'
webhdfsport = 50070
#webhdfsport = 50070

#zookeeper  = "localhost:2181"
zookeeper  = "node35.morado.com:2181"

#broker     = "localhost:9092"
broker     = "node35.morado.com:9092"

#### Module info:
#pkg_kafka_input_demo   =    '/home/pradeep/workspace/datatorrent/Megh/demos/kafka-input-module/target/kafka-input-module-demo-1.0.0-SNAPSHOT.apa'
#pkg_kafka-input_demo   =    '/home/chaitanya/malhar/Megh/demos/kafka-input-module/target/kafka-input-module-demo-1.0.0-SNAPSHOT.apa'
pkg_kafka_input_demo    =    '/home/dttbc/module/Megh/demos/kafka-input-module/target/kafka-input-module-demo-1.0.0-SNAPSHOT.apa'

#TC_CONFIG_DIR_PATH     =    '/home/pradeep/workspace/QA/framework/Tests/Modules/kafka-input-module/configFiles'
#TC_CONFIG_DIR_PATH     =    '/home/chaitanya/KafkaConfigs/'
TC_CONFIG_DIR_PATH     =    '/home/dttbc/IngestionAppTesting/configFiles'

#APP_DIR_PATH           =    'datatorrent/apps/'
APP_DIR_PATH           =    '/user/dttbc/datatorrent/apps/'

