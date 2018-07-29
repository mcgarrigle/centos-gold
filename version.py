#!/usr/bin/env python

# takes the path to an RPM and gets the version string
# excluding the el{n} release

import sys
import subprocess
import re

rpm = sys.argv[1]
cmd = "rpm -qp --queryformat %{version}.%{release} " + rpm
version = subprocess.check_output(cmd.split(' '))

m = re.search('^(.*?)\.el', version)
print m.group(1)
