import sys
sys.path.append("/var/dt/tf/etc/environments/")
from server import *




####Platform specific configurations:
dtserver  = 'node35.morado.com'
dtinstall = '/home/dttbc/datatorrent/current/'
dtbin     = dtinstall + 'bin/'
dtcpsh    = dtbin + 'dtingest'
dtcpjar   = '' #not needed now: '-j ' + dtinstall + 'apps/' + 'dtingest-1.0.0.apa'
####Ingestion specific configurations: Utilities
decyptor    = dtinstall + 'utils/' + 'dtingest-utils-1.1.0-RC2-jar-with-dependencies.jar'
decompactor = dtinstall + 'utils/' + 'dtingest-utils-1.1.0-RC2-jar-with-dependencies.jar'
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

