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
safeprint("Hello, I'm AnyRobot! 😀")


while True:
  safeprint("Type failure or success script pass to finish script gracefully: ")
  input_result = sys.stdin.readline().rstrip()
  if input_result == "failure":
    safeprint("Failed!")
    sys.exit(1) # Status code > 0 -> problem
  elif input_result == "success":
    safeprint("Gets done!")
    sys.exit(0)
    break
  else:
    safeprint("Wrong answer, try again...")
