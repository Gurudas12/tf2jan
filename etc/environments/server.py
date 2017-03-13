##########################
###For REST API calls:####
##########################

baseurl = 'http://node35.morado.com'
#baseurl = 'http://localhost'
gateway_port = '9090'
DT_PORT = '9090'
api_version = 'v2'
base_get_url = baseurl +':'+ gateway_port +  '/ws/' + api_version
dt_version = '3.5.0'


#############################
###For Commandline Usage:####
#############################

dtserver  = 'node35.morado.com'
#dtserver  = 'localhost'
sshuser   = 'dttbc'
#sshuser   = 'hduser'
sshkey    = '/root/.ssh/node30_id_rsa'
#sshkey    = '/home/hduser/.ssh/id_rsa'
sshport   = 22



