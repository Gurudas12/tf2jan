baseurl = 'http://node37.morado.com'
gateway_port = '9090'
sshuser = 'vagrant'
sshkey = '/var/dt/tf/etc/insecure_private_key'
sshport = 9444
dt_version = '2.1.0-RC4'
#Platform specific configurations:
dtserver  = 'mapr-node2.dt.lab'
dtinstall = '/home/vagrant/datatorrent/current/'
dtbin     = dtinstall + 'bin/'
dtcpsh    = dtbin + 'dtcp'
dtcpjar   = '-j ' + dtinstall + 'apps/' + 'ingestion-app-1.0.0-RC2.apa'

#Ingestion specific configurations: Utilities
decyptor    = '/home/dttbc/IngestionAppTesting/decryptor-0.0.1-SNAPSHOT-jar-with-dependencies.jar'
decompactor = '/home/dttbc/IngestionAppTesting/ingestion-utils-0.0.1-SNAPSHOT-jar-with-dependencies.jar'
#Ingestion specific configurations: Server setups
NN  =  'mapr-node2.dt.lab'
NNPORT =  8020
NFS = 'file:///disk5/dt-nfs-mount/IngestionAppTesting'
FTPUSER = 'ftp-dttbc'
FTPPSWD = 'dttbc'
FTPSRVR = 'node36.morado.com'
FTPPORT = 21
S3NUSER = 'AKIAIUUYNR43F76GOFHA'
S3NPSWD = 'cYKXtma2DLmfb3eQck0gD3ZjJ7ZJt0kYIYs4KoVN'
S3NURL  = 'ingestion-s3n.datatorrent.com'
S3BCKT_S  = 'ingestion-qas-s3n.datatorrent.com'
S3BCKT_D  = 'ingestion-qad-s3n.datatorrent.com'

