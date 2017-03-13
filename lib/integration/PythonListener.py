# -*- coding: utf-8 -*-
"""
Created on Mon Jun  1 12:02:43 2015
Listener to hook into robotframework

@author: aniruddha
"""
import os.path
import tempfile
from testopia import Testopia

class PythonListener:
    """Hook for various events in a test case's execution life
    This Listener Hook updates testopia test case state once a test case starts
    or ends.
    """

    ROBOT_LISTENER_API_VERSION = 2

    def __init__(self, run_id, case_id, build_id, environment_id):
        filename = '/var/dt/tf/logs/' + str(run_id) + '/' + str(case_id) + \
        '/listener.txt'
        outpath = (filename)
        #outpath = os.path.join(tempfile.gettempdir(), filename)
        self.outfile = open(outpath, 'w')
        self.run_id = int(run_id)
        self.case_id = int(case_id)
        self.build_id = int(build_id)
        self.environment_id = int(environment_id)

    def start_test(self, name, attrs):
        """Updates test case status in testopia to be running on start of
        execution"""

        #self.outfile = open(outpath, 'w')
        tags = ' '.join(attrs['tags'])
        self.outfile.write("- %s '%s' [ %s ] :: " % (name, attrs['doc'], tags))
        tcmscon = Testopia.from_config('/var/dt/tf/etc/testopia.cfg')
        tcmscon.testcaserun_update(run_id=self.run_id, case_id=self.case_id,\
        build_id=self.build_id, environment_id=self.environment_id,\
        case_run_status_id=4)

    def end_test(self, name, attrs):
        """Updates test case status in testopia to 'PASS' / 'FAIL' as matched.
        """
        if attrs['status'] == 'PASS':
            self.outfile.write('PASS\n')
            tcmscon = Testopia.from_config('/var/dt/tf/etc/testopia.cfg')
            tcmscon.testcaserun_update(run_id=self.run_id,\
            case_id=self.case_id, build_id=self.build_id,\
            environment_id=self.environment_id, case_run_status_id=2)
            #self.writemsg()
        else:
            self.outfile.write('FAIL: %s\n' % attrs['message'])
            tcmscon = Testopia.from_config('/var/dt/tf/etc/testopia.cfg')
            tcmscon.testcaserun_update(run_id=self.run_id,\
            case_id=self.case_id, build_id=self.build_id, \
            environment_id=self.environment_id, case_run_status_id=3)
            #self.writemsg()

    def end_suite(self, name, attrs):
        self.outfile.write('%s\n%s\n' % (attrs['status'], attrs['message']))

    def close(self):
        self.outfile.close()
