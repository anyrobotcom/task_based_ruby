#!/usr/bin/env python

import os
import sys
from pprint import pprint

# Test output with

print("Hello, I'm AnyRobot! 😀")

# Test Chromedriver (remember to install it first)

chromedriver_result = os.popen("chromedriver --version").read()

if chromedriver_result.count("ChromeDriver") > 0:
  print("Chromedriver is present ✅")
else:
  print("No chromedriver present, aborting 🛑")
  sys.exit(1) # Status code > 0 -> problem

# Input ARGV + ENV

print("Arguments: %s" % sys.argv)
print("Environment: %s" % os.environ)

# Response from user / stdin + failure or success

while True:
  print("Type failure or success script pass to finish script gracefully: ")
  input_result = sys.stdin.readline().rstrip()
  if input_result == "failure":
    print("Failed!")
    sys.exit(1) # Status code > 0 -> problem
  elif input_result == "success":
    print("Gets done!")
    break
  else:
    print("Wrong answer, try again...")