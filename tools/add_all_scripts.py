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

dir_list = ["system", "service", "daemon", "net"]
_cwd = os.getcwd()

####################################
# No functions below here.
####################################

clock_0 = datetime.datetime.now()
scriptcount_int = 0

for _dir in dir_list:
	print "Converting %s dicectory...\n" %(_dir)
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
seconds = timediff.seconds
hours = 0
minutes = 0
if seconds > 3599:
	hours = seconds / 3600
	seconds = seconds - (hours * 3600)
if seconds > 59:
	minutes = seconds / 60
	seconds = seconds - (minutes * 60)
hours = str(hours)
minutes = str(minutes)
if len(minutes) == 1:
	minutes = "0" + minutes
seconds = str(seconds)
if len(seconds) == 1:
	seconds = "0" + seconds
time_str = hours + ":" + minutes + ":" + seconds
print str(scriptcount_int) + " scripts converted in %s.\n" %(time_str)

