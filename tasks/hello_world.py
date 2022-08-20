#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
from pprint import pprint

def safeprint(s):
  try:
    print(s)
  except UnicodeEncodeError:
    if sys.version_info >= (3,):
      print(s.encode('utf8').decode(sys.stdout.encoding))
    else:
      print(s.encode('utf8'))


# Test output with

safeprint("Hello, I'm AnyRobot! :)")

# Test Chromedriver (remember to install it first)

chromedriver_result = os.popen("chromedriver --version").read()

if chromedriver_result.count("ChromeDriver") > 0:
  safeprint("Chromedriver is present OK")
else:
  safeprint("No chromedriver present, aborting STOP")
  sys.exit(1) # Status code > 0 -> problem

# Input ARGV + ENV

safeprint("Arguments: %s" % sys.argv)
safeprint("Environment: %s" % os.environ)