from __future__ import with_statement

from constants import *
import inotifyx
import subprocess
import optparse
import fnmatch
import time
import sys
import os
import yaml
from fireworks import Firework, Workflow, FWorker, LaunchPad, ScriptTask, PyTask
from testopia import Testopia
from fireworks.core.rocket_launcher import rapidfire
import threading
sys.path.append("/var/dt/tf/lib/integration/")
from HookFW import runCase
import MySQLdb


class Reporter(object):
    """Responsible for displaying info on the terminal."""

    def __init__(self):
        """Creates a new reporter."""

        self.run_number = 0

    def __enter__(self):
        """Report starting."""

        print 'Setting up monitoring of paths'
        return self

    def monitor_count(self, count):
        """Report number of paths monitored."""

        print 'Monitoring %s paths' % count

    def begin_run(self, change_set, command):
        """Report the beginning of the run."""

        self.run_number += 1
        print '=' * WIDTH
        print 'Run Number : %s' % self.run_number
        print 'Files      : %s' % ' '.join(change_set)
        print 'Command    : %s' % ' '.join(command)
        print

    def end_run(self, ignored_change_set):
        """Report the end of the run."""

        print
        if ignored_change_set:
            print 'Ignoring changed files : %s' % ' '.join(ignored_change_set)
            print
        print '-' * WIDTH

    def __exit__(self, e_type, e_value, tb):
        """Print blank line so shell prompt on clean new line."""

        print


class ChangeMonitor(object):
    """Responsible for detecting files being changed."""

    def __init__(self, paths, white_list, black_list, delay):
        """Creates a new file change monitor."""

        # Events of interest.
        self.WATCH_EVENTS = inotifyx.IN_CREATE | inotifyx.IN_MODIFY | inotifyx.IN_DELETE | inotifyx.IN_DELETE_SELF | inotifyx.IN_MOVE

        # Remember params.
        self.white_list = white_list
        self.black_list = black_list
        self.delay = delay

        # Init inotify.
        self.fd = inotifyx.init()

        # Watch specified paths.
        self.watches = {}
        self.watches.update((inotifyx.add_watch(self.fd, path, self.WATCH_EVENTS), path)
                            for path in paths)

        # Watch sub dirs of specified paths.  Ensure we modify dirs
        # variable in place so that os.walk only traverses white
        # listed dirs.
        for path in paths:
            for root, dirs, files in os.walk(path):
                dirs[:] = [dir for dir in dirs if self.is_white_listed(dir)]
                self.watches.update((inotifyx.add_watch(self.fd, os.path.join(root, dir), self.WATCH_EVENTS), os.path.join(root, dir))
                                    for dir in dirs)

    def monitor_count(self):
        """Return number of paths being monitored."""

        return len(self.watches)

    def __iter__(self):
        """Iterating a monitor returns the next set of changed files.

        When requesting the next item from a monitor it will block
        until file changes are detected and then return the set of
        changed files.
        """

        while True:
            # Block until events arrive.
            events = inotifyx.get_events(self.fd)

            # Collect any events that occur within the delay period.
            # This allows events that occur close to the trigger event
            # to be collected now rather than causing another run
            # immediately after this run.
            if self.delay:
                time.sleep(self.delay)
                events.extend(inotifyx.get_events(self.fd, 0))

            # Filter to events that are white listed.
            events = [event for event in events if self.is_white_listed(event.name)]

            if events:
                # Track watched dirs.
                for event in events:
                    if event.mask & inotifyx.IN_ISDIR and event.mask & inotifyx.IN_CREATE:
                        self.watches[inotifyx.add_watch(self.fd, os.path.join(self.watches.get(event.wd), event.name), self.WATCH_EVENTS)] = os.path.join(self.watches.get(event.wd), event.name)
                    elif event.mask & inotifyx.IN_DELETE_SELF:
                        self.watches.pop(event.wd, None)

                # Supply this set of changes to the caller.
                change_set = set(os.path.join(self.watches.get(event.wd, ''), event.name or '')
                                 for event in events)
                yield change_set

    def clear(self):
        """Clears and returns any changed files that are waiting in the queue."""

        events = inotifyx.get_events(self.fd, 0)
        change_set = set(os.path.join(self.watches.get(event.wd, ''), event.name or '')
                         for event in events
                         if self.is_white_listed(event.name))
        return change_set

    def is_white_listed(self, name):
        """Return whether name is in or out."""

        # Events with empty name are in as we have a watch on that
        # path.
        if not name:
            return True

        # Names in white list are always considered in.
        for pattern in self.white_list:
            if fnmatch.fnmatch(name, pattern):
                return True

        # Names in black list are always considered out.
        for pattern in self.black_list:
            if fnmatch.fnmatch(name, pattern):
                return False

        # If not white or black listed then considered in.
        return True


class Runner(object):
    """Responsible for running a specified command upon file changes."""

    def __init__(self, reporter, change_monitor, ignore_events, no_initial_run, with_arguments, command):
        """Creates a new command runner."""

        self.reporter = reporter
        self.change_monitor = change_monitor
        self.ignore_events = ignore_events
        self.no_initial_run = no_initial_run
        self.with_arguments = with_arguments
        self.command = []
        for part in command:
            self.command.extend(part.split())

    def do_command(self, command):
        """Invoke our command."""

        subprocess.call(command)

    def do_run(self, change_set):
        """Perform a command run."""

        command = self.command + (list(change_set) if self.with_arguments else [])
        self.reporter.begin_run(change_set, command)
        self.do_command(command)
        ignored_change_set = self.change_monitor.clear() if self.ignore_events else set()
        self.reporter.end_run(ignored_change_set)

    def do_run_iterative(self,change_set):
        """Perform a command run on each of the files changed"""
        print "change set: " + str(list(change_set))
        command = self.command + (list(change_set) if self.with_arguments else [])
        self.reporter.begin_run(change_set, command)
        self.do_command(command)
        ignored_change_set = self.change_monitor.clear() if self.ignore_events else set()
        self.reporter.end_run(ignored_change_set)
        chtype = type (change_set)
        print chtype
        chsetlist = list(change_set)
        chsetlistp = type(chsetlist)
        print chsetlistp
        print chsetlist
        for listitem in chsetlist:
            if listitem:
                if os.path.exists(listitem):
                    print listitem + " exists, nosier2"
                    processfile(listitem)
                else:
                    print listitem + " got deleted nosier2"
                    
    def main_loop(self):
        """Waits for a set of changed files and then does a command run."""

        # Report number of paths being monitored.
        self.reporter.monitor_count(self.change_monitor.monitor_count())

        # Do initial command run.
        if not self.no_initial_run:
            self.do_run_iterative(set())
            #self.do_run(set())
        

        # Monitor and run the specified command until keyboard interrupt.
        for change_set in self.change_monitor:
            self.do_run_iterative(change_set)
            #self.do_run(change_set)


def processfile(runfile):
    """Function to process testopia run yaml file and create workflows, add them 
    to run in fireworks"""
    with open(runfile,'r') as f:
        run_details = yaml.load(f)
    testcases = run_details['test_run']['cases']
    print 'testcases:\n'
    print testcases
    testcasetype = type(testcases)
    print testcasetype
    run_id = int(run_details['test_run']['run_id'])
    print run_id
    environment_id = int(run_details['test_run']['environment_id'])
    print environment_id
    tcms = Testopia.from_config('/var/dt/tf/etc/testopia.cfg')
    environment_details = tcms.environment_get(environment_id)
    print environment_details
    rundetailsfromtcms = tcms.testrun_get(run_id)
    product_version =rundetailsfromtcms['product_version']
    build_id = rundetailsfromtcms['build_id']
    buildinfo = tcms.build_get(build_id)
    print buildinfo
    build_name = buildinfo['name']
    print "build name: " + build_name
    print "product_version " + product_version
    environment_name = environment_details['name']
    print environment_name
    environment_file = '/var/dt/tf/etc/environments/' + environment_name + '.py'
    environment_filepyc = environment_file + 'c'
    if os.path.isfile(environment_filepyc):
        print "environment pyc file is present, deleting it"
        os.remove(environment_filepyc)
    else:
        print "No cached environment pyc file found"
    print environment_file
    testsonfire = []
    fwsequence = {}
    fwkey = ''
    fwvalue = ''
    for testcase in testcases.keys():
        case_id = int(testcase)
        testcase_name = run_details['test_run']['cases'][testcase]['summary']
        argsf = [run_id,case_id,build_id,environment_id,environment_name,environment_file,testcase_name,product_version,build_name]
        fw_test = Firework(PyTask(func='HookFW.runCase',args=argsf))
        print "argsf are:"
        print argsf
        testsonfire.append(fw_test)
        if fwvalue:
            fwsequence[fwvalue] = fw_test
            fwvalue = fw_test
        else:
            fwvalue = fw_test

    #To be run as last firework in the workflow, to compile logs for the entire set of testcases
     
    rebotcmd = "cd /var/dt/tf/logs/" + str(run_id) + '; rebot -N "DTTF" -R */*.xml; ln -s report.html index.html; echo ok '
    fw_test = Firework(ScriptTask.from_str(rebotcmd))
    testsonfire.append(fw_test)
    fwsequence[fwvalue] = fw_test
    print "tests on fire:"
    print testsonfire   
    print "test sequence:"
    print fwsequence 
    workflow = Workflow(testsonfire,fwsequence)
    launchpad = LaunchPad()
    launchpad.add_wf(workflow)    
#    launcher = threading.Thread(target=rapidfire,rapidfire(launchpad, FWorker())
def main():
    """Process command line, setup and enter main loop."""

    try:
        # Process command line options.
        parser = optparse.OptionParser(usage=USAGE_TEXT, version=VERSION_TEXT)
        parser.add_option('-p', '--path', action='append',
                          help='add a path to monitor for changes, if no paths are specified then the current directory will be monitored')
        parser.add_option('-d', '--delay', type='float', default=0.1,
                          help='how long to wait for additional events after a command run is triggered, defaults to %default second')
        parser.add_option('-i', '--ignore-events', action='store_true', default=False,
                          help='whether to ignore events that occur during the command run, defaults to %default')
        parser.add_option('-w', '--white-list', action='append', default=[], metavar='FILE',
                          help='add a file to the white list, ensure globs are quoted to avoid shell expansion')
        parser.add_option('-b', '--black-list', action='append', default=[], metavar='FILE',
                          help='add a file to the black list, ensure globs are quoted to avoid shell expansion')
        parser.add_option('-l', '--no-default-black-list', action='store_true', default=False,
                          help='''don't add the following to the black list: %s''' % ' '.join(BUILTIN_BLACK_LIST))
        parser.add_option('-r', '--no-initial-run', action='store_true', default=False,
                          help='''don't perform an initial run of the command, instead start monitoring and wait for changes''')
        parser.add_option('-a', '--with-arguments', action='store_true', default=False,
                          help='''whether to pass the updated file path as an argument to the command run''')

        options, command = parser.parse_args()

        if not command:
            parser.print_help()
            return

        paths = options.path or ['.']
        delay = options.delay
        ignore_events = options.ignore_events
        white_list = options.white_list
        black_list = options.black_list
        if not options.no_default_black_list:
            black_list.extend(BUILTIN_BLACK_LIST)
        no_initial_run = options.no_initial_run
        with_arguments = options.with_arguments

        # Create the reporter that prints info to the terminal.
        with Reporter() as reporter:

            # Create the monitor that watches for file changes.
            change_monitor = ChangeMonitor(paths, white_list, black_list, delay)

            # Create the runner that invokes the command on file
            # changes.
            runner = Runner(reporter, change_monitor, ignore_events, no_initial_run, with_arguments, command)

            # Enter the main loop until we break out.
            runner.main_loop()

    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    main()
