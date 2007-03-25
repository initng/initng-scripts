#!/usr/bin/python

"""
Usage:
	add_all_scripts.py /path/to/initng-ifiles/trunk/initfiles /path/to/initng-scripts/trunk/initfiles
"""

#######################
# Imports
#######################

import os, sys, datetime


######################
# Globals
######################

try:
	ifiles_path = sys.argv[1]
	scripts_path = sys.argv[2]
except:
	print "You must specify two paths.\n"
	sys.exit()

dir_list = ["system", "service", "net", "daemon", "daemon/bluetooth",
            "daemon/exim", "daemon/lirc", "daemon/nut", "daemon/vmware"]
_cwd = os.getcwd()

####################################
# No functions below here.
####################################

clock_0 = datetime.datetime.now()
scriptcount_int = 0

for _dir in dir_list:
	print "Converting %s directory ...\n" %(_dir)
	os.chdir(scripts_path + "/" + _dir)
	ifiles_list = os.listdir(ifiles_path + "/" + _dir)
	for i in ifiles_list:
		if i.endswith(".ii"):
			print "Converting %s ..." %(i)
			os.system("python %s/ifile2script.py %s/%s/%s" %(_cwd, ifiles_path, _dir, i))
			scriptcount_int = scriptcount_int + 1
	print " ... done.\n"

clock_1 = datetime.datetime.now()
timediff = clock_1 - clock_0
time_str = str(timediff.seconds) + "." + str(timediff.microseconds)
print str(scriptcount_int) + " scripts converted in %s seconds.\n" %(time_str)

