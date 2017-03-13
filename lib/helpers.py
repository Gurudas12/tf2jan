import sys
import os
import unicodedata
import yaml
import signal
from robot.api import logger
sys.path.append("/home/aditya/tf2jan/lib/integration")
from xvfbhandler import xvfbhandler
#@staticmethod
def CheckIfMT(val1, val2):
    """Accepts two values and returns true if first value is greater than second"""
    logger.debug("testing if %d >  %d" %( val1, val2))
    if val1 > val2:
        logger.debug("%d is more than %d" %( val1, val2))
        return True
    else:
        logger.debug("%d is less than %d" %( val1, val2))
        return False

#@staticmethod
def CheckIfLT(val1, val2):
    """Accepts two values and returns true if first value is smaller than second"""
    if val1 < val2:
        return True
    else:
        return False    
def GetType(oftype):
    """Returns type of object"""
    mtype=type(oftype)
    logger.debug("Get type: %s" % mtype)
    return mtype

def ConUniToInt(tobeconverted):
    """Convert Unicode To Int"""
    converted2int = long(unicodedata.normalize('NFKD',tobeconverted ).encode('ascii','ignore'))
    return converted2int

def LoadYaml(filepath):
    """Load YAML file and return dict"""
    with open(filepath, 'r') as f:
        doc = yaml.load(f)
    logger.debug(doc)
    return doc

def GetPID():
    """Returns PID of this process"""
    mypid = os.getpid()
    logger.debug("My PID is %d" % mypid)
    return mypid


def TerminatePID(pid):
    """Tries to terminate the process by pid"""
    logger.info("Terminating the process %d" % (pid))
    os.kill(pid, signal.SIGTERM)


def SetupXVFB(width=1280, height=720,colordepth=24):
    """Sets up xvfb display, returns the display id and pid"""
    vdisplay = xvfbhandler(int(width), int(height), int(colordepth))
    return vdisplay.displayid,vdisplay.xvfbpid
    
