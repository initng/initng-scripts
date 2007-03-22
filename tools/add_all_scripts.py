#!/usr/bin/python

"""
Usage:
	add_all_scripts.py /path/to/initng-ifiles/trunk/initfiles /path/to/initng-scripts/trunk/initfiles 
"""

#######################
# Imports
#######################

import os, sys, os.path


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

for _dir in dir_list:
	print "Converting %s dicectory...\n" %(_dir)
	os.chdir(scripts_path + "/" + _dir)
	ifiles_list = os.listdir(ifiles_path + "/" + _dir)
	for i in ifiles_list:
		if i.endswith(".ii"):
			print "Converting %s ..." %(i)
			os.system("python %s/ifile2script.py %s/%s/%s" %(_cwd, ifiles_path, _dir, i))
	print " ... done.\n"
	