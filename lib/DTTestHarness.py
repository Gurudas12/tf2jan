import requests 
import sys
import json
import argparse
import os
import unicodedata
from robot.api import logger
import helpers
class DTTestHarness(object):
    """Test library for testing DT Rest APIs 

    """

    def __init__(self):
        self._statuscode = 0 
        self.rjson = ''
        self.rheaders = ''
        print 'placeholder'
     
