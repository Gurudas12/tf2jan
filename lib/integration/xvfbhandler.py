# -*- coding: utf-8 -*-
"""
Created on Thu Jun 25 13:17:24 2015

@author: aniruddha
"""
import os
import fnmatch
import subprocess
import time

class xvfbhandler(object):
    """"Handle initiation and destruction of XVFB & fluxbox instance"""
    def __init__(self, width=1024, height=768, colordepth=24):
        self.width = width
        self.height = height
        self.colordepth = colordepth
        self.proc = None
        self.displayid = 0
        self.mindisplayno = 0
        self.maxdisplayno = 0
        self.locks = self.list_locks()
        print "locks:"
        print self.locks
        print self.displayid
        self.xvfbpid = self.start()
        
    def list_locks(self):
        tmpdir = '/tmp'
        pattern = '.X*-lock'
        lockfiles = fnmatch.filter(os.listdir(tmpdir), pattern)
        ls = [os.path.join(tmpdir, child) for child in lockfiles]
        ls = [p for p in ls if os.path.isfile(p)]
        print ls
        if not ls:
            print "no ls"
            displayid = 0
            self.displayid = displayid
            print displayid
            return displayid
        else:
            ls2 = map(lambda x: int(x.split('X')[1].split('-')[0]),ls)
            print ls2
            self.mindisplayno = min(ls2)
            print self.mindisplayno
            self.maxdisplayno = max(ls2)
            print self.maxdisplayno
            lenofdisplays = len(ls2)
            self.locks = ls2
            print lenofdisplays
            if lenofdisplays == self.maxdisplayno + 1:
                self.displayid = self.maxdisplayno + 1
                return self.displayid
            else:
                print "finding lowest available display"
                self.find_lowestavailable()
            return ls2
    
    def find_lowestavailable(self):
        for candidate in range(self.mindisplayno,self.maxdisplayno):
            print ("Current candidate is : %d" % candidate)
            if not candidate in self.locks:
                self.displayid = candidate
                return candidate
                
    def start(self):
        self.xvfb_cmd = ['Xvfb', ':%d' % (self.displayid,), '-screen', '0','%dx%dx%d' % (self.width, self.height, self.colordepth)]
        self.proc = subprocess.Popen(self.xvfb_cmd, stdout=open(os.devnull),
                                     stderr=open(os.devnull),)
	print "xvfb pid is: %d" % self.proc.pid
        os.environ['DISPLAY'] = ':%s' % self.displayid
        self.proc2 = subprocess.Popen('fluxbox',stdout=open(os.devnull),stderr=open(os.devnull))
	print "fluxbox pid is: %d" % self.proc2.pid
        print "display id is: %d" % self.displayid
 
	return self.proc.pid
                                     
    def getDisplayid(self):
        """Returns Display ID"""
        return self.displayid
        
    def getXVFBPID(self):
        """Returns XVFB instance PID"""
        return self.xvfbpid
        
        
        
#vdisplay = xvfbhandler(width=1280, height=720)
