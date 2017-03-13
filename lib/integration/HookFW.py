# -*- coding: utf-8 -*-
"""
Created on Fri Jun  5 12:46:18 2015

@author: aniruddha
"""
import os
import errno
import time
import shutil
from robot import run


class HookFW:
    """ Provide hooks to be used in Fireworks"""

    def __init__(self, filename, sleep=10, maxWait=600):
        """Initialize"""
        self.filename = filename
        print "Initilizing with " + self.filename
        self.sleep = sleep
        self.maxWait = maxWait
        self.totalWait = 0
        print "Sleep time is ", self.sleep
        #self.lockLoop()
#        while self.AcquireEnvLock('/tmp/abc.txt'):
#            print "lock already acquired"

    def AcquireEnvLock(self):
        """Tries To acquire lock on environment"""
        flags = os.O_CREAT | os.O_EXCL | os.O_WRONLY
        try:
            file_handle = os.open(self.filename, flags)
        except OSError as e:
            if e.errno == errno.EEXIST:
            # Failed as the file already exists.
                print "Couldn't acquire the lock"
#                pass
            else:
                # Something unexpected went wrong so reraise the exception.
                raise

        else:  # No exception, so the file must have been created successfully.
            with os.fdopen(file_handle, 'w') as file_obj:
                # Using `os.fdopen` converts the handle to an object that acts
                #like a regular Python file object, and the `with`
                #context manager means the file will be automatically closed
                #when we're done with it.
                file_obj.write("Its locked.\n")
                print "Lock acquired : %s" % time.ctime()
                return True

    def lockLoop(self):
        """Main Loop, keeps trying to acquire lock over environment
        for maxWait (default 60), tries to acquire lock after given sleep time
        (default 10)"""
        while True:
            if self.AcquireEnvLock():
                print "locked now: %s" % time.ctime()
                return True
#               break
            else:
                print "Started sleeping : %s" % time.ctime()
                time.sleep(self.sleep)
                self.totalWait = self.totalWait + self.sleep
                print "Total wait till now  : %d" % self.totalWait
                if self.totalWait >= self.maxWait:
                    return False
#                   raise AssertionError("Went past maxwait %d," % self.maxWait)




def runCase(run_id, case_id, build_id, environment_id, environment_name='cdh',\
    varfile='/var/dt/tf/etc/environments/cdh.py', testcasename='REST API Ping',\
    product_version='3.2.0',build_name='3.2.0'):
    """runs a test case, given these parameters:
    run_id,case_id,build_id,environment_id,environment_name='<as it appears in
    testopia>',varfile='<full path to file>',testcasename
    """
    #print product_version
    lockfile = '/var/dt/tf/tmp/locks/' + environment_name + '.lock'
    HookInit = HookFW(lockfile, 5, 600)
    logdir = '/var/dt/tf/logs/' + str(run_id) + '/' + str(case_id)
    stdoutfile = logdir + '/stdout.txt'
    listenerfile = '/var/dt/tf/lib/integration/PythonListener.py:'
    listenerargs = str(run_id) + ":" + str(case_id) + ":" + str(build_id) + \
    ":" + str(environment_id)
    prodvar = 'dt_version="' + product_version.strip() +'"\n'
    #print prodvar
    buildvar = 'dt_build_name ="' + build_name.strip()+'"\n'
    lstrnr = listenerfile + listenerargs
    if HookInit.lockLoop():
        print("Locked it , %s" % time.ctime())
        os.makedirs(logdir)
        shutil.copy(varfile, logdir)
        Vfile=logdir+'/'+os.path.basename(varfile)
        with open(Vfile,"a") as varfhandle:
            varfhandle.write('\n'+prodvar+buildvar)
            varfhandle.close()

        with open(stdoutfile, 'w') as stdout:
            run('/var/dt/tf/Tests', test=testcasename, variablefile=varfile,\
            vel='DEBUG', outputdir=logdir, report='report.html',\
            log='log.html', listener=lstrnr, stdout=stdout)
#            variable=prodvar)
    os.remove(lockfile)
    print ("Released lock, %s" % time.ctime())

