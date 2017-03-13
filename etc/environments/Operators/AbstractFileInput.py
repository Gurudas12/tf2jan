import sys
sys.path.append("/var/dt/tf/etc/environments/")
#sys.path.append("/home/pradeep/workspace/QA/framework/etc/environments/")
from server import *

#dtcli related parameters: +++++++++++++++++++++++++++++++++++++++++++++++++++++
dtinstall              = '/home/dttbc/datatorrent/current/'
#dtinstall              = '/home/hduser/datatorrent/current/'
dtbin                  = dtinstall + 'bin/'
dtcli_log              = '/tmp/AbstractFileInput-robot.log'

#General info: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
app_pkg                = '/home/dttbc/apps/fileIO-1.0-SNAPSHOT.apa'
#app_pkg                = '/tmp/fileIO-1.0-SNAPSHOT.apa'
APPLICATION_NAME       = 'ThroughputBasedFileIO'
OPERATOR_NAME          = 'read'

#HDFS: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
iNN     =  'node35.morado.com'
#iNN     =  'localhost'
iNNPORT =  '8020'
#iNNPORT =  '54310'

oNN     =  'node35.morado.com'
#oNN     =  'localhost'
oNNPORT =  '8020'
#oNNPORT =  '54310'

iHDFS = 'hdfs://' + iNN + ':' + iNNPORT
oHDFS = 'hdfs://' + oNN + ':' + oNNPORT

BASEDIR = '/user/dttbc/DATASETS'
#BASEDIR = '/user/hduser/DATASETS'
HDFS_INDIR = iHDFS + BASEDIR + '/ing-source-data'
HDFS_OUTDIR = oHDFS + BASEDIR + '/ing-dest-data/AbstractFileInput'

#NFS: ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
NFS = 'file:///disk5/dt-nfs-mount/IngestionAppTesting'
NFS_INDIR = NFS + BASEDIR + '/ing-source-data'

#Pure-FTP: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FTPUSER = 'ftp-dttbc'
FTPPSWD = 'dttbc'
FTPPORT = '21'
FTPSRVR = 'node34.morado.com'

FTP = 'ftp://' + FTPUSER + ':' + FTPPSWD + '@' + FTPSRVR + ':' + FTPPORT
FTP_INDIR = FTP + '/home/' + FTPUSER + BASEDIR + '/ing-source-data'

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

