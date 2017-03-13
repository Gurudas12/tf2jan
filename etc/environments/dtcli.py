import sys
sys.path.append("/var/dt/tf/etc/environments/")
from server import *

dtinstall              = '/home/dttbc/datatorrent/current/'
dtbin                  = dtinstall + 'bin/'
dtcli_log              = '/tmp/dtcli_log.txt'

#Packages info:
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
pkg_mobile_demo     =      '/home/dttbc/mobile-demo-3.4.0.apa'
pkg_pi_demo            = '/home/dttbc/pi-demo-3.4.0.apa'
