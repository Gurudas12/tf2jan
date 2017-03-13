import sys
sys.path.append("/var/dt/tf/etc/environments/")
from server import *


# Build download variables
#download_link = https://www.datatorrent.com/downloads/${dt_version}/datatorrent-rts-${dt_version}.bin
#installer =  datatorrent-rts-${dt_version}.bin
#Hadoop_Executable_Location = /usr/bin/hadoop

## For dtcli tests
dtcli_log   = '/tmp/dtcli_log.txt'
#Packages info:
dtinstall              = '/home/dttbc/datatorrent/current/'
pkg_pi_demo            = dtinstall + '/demos/' + 'pi-demo-'+ dt_version +'.apa'
pkg_dimensions_demo    = dtinstall + '/demos/' + 'dimensions-demo-'+ dt_version +'.apa'
pkg_frauddetect_demo   = dtinstall + '/demos/' + 'frauddetect-demo-'+ dt_version +'.apa'
pkg_machinedata_demo   = dtinstall + '/demos/' + 'machinedata-demo-'+ dt_version +'.apa'
pkg_mobile_demo        = dtinstall + '/demos/' + 'mobile-demo-'+ dt_version +'.apa'
pkg_twitter_demo       = dtinstall + '/demos/' + 'twitter-demo-'+ dt_version +'.apa'
pkg_wordcount_demo     = dtinstall + '/demos/' + 'wordcount-demo-'+ dt_version +'.apa'
pkg_yahoo_finance_demo = dtinstall + '/demos/' + 'yahoo-finance-demo-'+ dt_version +'.apa'
pkg_ingestion_apa      = dtinstall + '/apps/'  + 'dtingest-1.0.0.apa'
pkg_ingestion_jar      = '/home/dttbc/IngestionAppTesting/.ingestion-app-2.2.0-SNAPSHOT.jar'


## For dtingest tests
#platform specific configurations:
dtserver  = 'node34.morado.com'
dtinstall = '/home/dttbc/datatorrent/current/'
dtbin     = dtinstall + 'bin/'
dtcpsh    = dtbin + 'dtingest'
dtcpjar   = '' #not needed now: '-j ' + dtinstall + 'apps/' + 'dtingest-1.0.0.apa'
####Ingestion specific configurations: Utilities
decyptor    = dtinstall + 'utils/' + 'dtingest-utils-1.1.0-jar-with-dependencies.jar'
decompactor = dtinstall + 'utils/' + 'dtingest-utils-1.1.0-jar-with-dependencies.jar'
####Ingestion specific configurations: Server setups
BASEDIR = '/user/dttbc/DATASETS'
#HDFS:
iNN     =  'node34.morado.com'
iNNPORT =  8020
oNN     =  'node34.morado.com'
oNNPORT =  8020

#NFS:
NFS = 'file:///disk5/dt-nfs-mount/IngestionAppTesting'
#FTP: vsftpd
FTPUSER = 'ftp-dttbc'
FTPPSWD = 'dttbc'
FTPPORT = 21
#Pure-FTP:
FTPSRVR = 'node34.morado.com'
#S3N:
S3NUSER = 'AKIAIUUYNR43F76GOFHA'
S3NPSWD = 'cYKXtma2DLmfb3eQck0gD3ZjJ7ZJt0kYIYs4KoVN'
S3NURL  = 'ingestion-s3n.datatorrent.com'
S3BCKT_S  = 'ingestion-qas-s3n.datatorrent.com'
S3BCKT_D  = 'ingestion-qad-s3n.datatorrent.com'



