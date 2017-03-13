from time import sleep
import sys
from random import uniform

def type(s):
    for c in s:
        sys.stdout.write('%s' % c)
        sys.stdout.flush()
        sleep(uniform(0, 0.3))

name = raw_input("What is your name? ")
type("Hello " + name +"\n")