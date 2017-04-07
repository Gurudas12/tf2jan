##########################
###For REST API calls:####
##########################

baseurl = 'http://ameya-m4master'
#baseurl = 'http://localhost'
gateway_port = '9090'
DT_PORT = '9090'
api_version = 'v2'
base_get_url = baseurl +':'+ gateway_port +  '/ws/' + api_version
dt_version = '3.7.0'


#############################
###For Commandline Usage:####
#############################

dtserver  = 'ameya-m4master'
#dtserver  = 'localhost'
sshuser   = 'localhost'
#sshuser   = 'hduser'
sshkey    = '/root/.ssh/node30_id_rsa'
#sshkey    = '/home/hduser/.ssh/id_rsa'
sshport   = 22

#######################
###For GUI Testing:####
#######################


username  =  'dttbc'
url = 'localhost:9090/'
version_string  =   '3.6.0-rts3.8.0'


