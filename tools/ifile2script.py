#!/usr/bin/python

"""
Usage:
	ifile2script.py path/to/<scriptname>.ii
	
	The converted script will be placed in CWD.
"""

#######################
# Imports
#######################

import os, sys, os.path


######################
# Globals
######################

try:
	scriptpath = sys.argv[1]
except:
	print "You must specify a script to convert.\n"
	sys.exit()

if not os.path.isfile(scriptpath):
	print "The scriptpath given is not a file.\n"
	sys.exit()

scriptname = os.path.basename(scriptpath)

######################
# Functions
######################

####################################
# No functions below here.
####################################

_file = open(scriptpath, "r")
file_str = _file.read()
_file.close()
file_list = file_str.splitlines()

iregister_list = []
iset_list = []
iexec_list = []
idone_list = []
service_list = []
daemon_list = []
virtual_list = []
service_and_daemon_list = []
env_list = []
new_file_list = []
env_list_mode = None
iexec_list_mode = None
iset_list_mode = None
ifd_mode = None
file_mode = "0"
file_int = 0

for i in file_list:
	i_int = len(i)
	if i.startswith("service"):
		_service = i.split()[1].strip("{").strip()
		service_list.append(_service)
		iset_list.append(_service)
		service_and_daemon_list.append(_service)
		file_mode = "1"
	
	elif i.startswith("daemon"):
		_service = i.split()[1].strip("{").strip()
		daemon_list.append(_service)
		iset_list.append(_service)
		service_and_daemon_list.append(_service)
		file_mode = "1"
	
	elif i.startswith("virtual"):
		_service = i.split()[1].strip("{").strip()
		virtual_list.append(_service)
		iset_list.append(_service)
		service_and_daemon_list.append(_service)
		file_mode = "1"
		
	elif file_mode == "1":
		i = i.strip(" \t")
		if i.startswith("script"):
			file_mode = "2"
			iexec_list.append(_service)
			iexec_list.append("%" + i.split()[1].strip() + "%")
			
		elif i.startswith("need") or i.startswith("use") or i.startswith("also_start") or \
				i.startswith("pid_file"):
			_str = i.split("=")[-1].strip(" ;")
			if i.startswith("need"):
				_sel = "need = "
			elif  i.startswith("use"):
				_sel = "use = "
			elif  i.startswith("also_start"):
				_sel = "also_start = "
			elif  i.startswith("pid_file"):
				_sel = "pid_file = "
			if iset_list_mode != ifd_mode and ifd_mode != None:
				iset_list.append(ifd_mode)
				iset_list_mode = ifd_mode
			iset_list.append(_sel + '"' + _str + '"')
		
		elif i.startswith("env"):
			_str = i.split(" ", 1)[1].strip(" ;")
			if i.split()[0].strip() == "env_file":
				_str = _str.strip(" ;=")
				_str = "source " + _str
			if env_list_mode != ifd_mode and ifd_mode != None:
				env_list.append(ifd_mode)
				env_list_mode = ifd_mode
			env_list.append(_str)
				
		elif i.startswith("exec"):
			_list = i.split(" ", 1)[-1].strip(" ;").split("=")
			_sel = "exec "
			if iset_list_mode != ifd_mode and ifd_mode != None:
				iset_list.append(ifd_mode)
				iset_list_mode = ifd_mode
			iset_list.append(_sel + _list[0].strip() + ' = "' + _list[1].strip() + '"')
		
		elif i.startswith("#ifd") or i.startswith("#elsed"):
			ifd_mode = i.strip()
			
		elif i.startswith("#endd"):
			ifd_mode = None
			if env_list_mode != None:
				env_list.append("#endd")
				env_list_mode = None
			if iset_list_mode != None:
				iset_list.append("#endd")
				iset_list_mode = None
				
		elif i != "" and i != "}" and not i.startswith("#"):
			if "#" in i:
				_int = i.find("#")
				i = i[:_int]
			iset_list.append(i.strip(" ;"))
	
	elif file_mode == "2":
		_str = i.strip(" \t")
		if _str == "};":
			file_mode = "1"
		else:
			iexec_list.append(i)
			
	file_int = file_int + i_int


new_file = open(os.getcwd() + "/" + scriptname.rstrip("i") + "ss", "w")

_str = """# NAME:
# DESCRIPTION:
# WWW:
"""

for i in range(3):
	if file_list[i].startswith("#"):
		new_file.write(file_list[i] + "\n")
	else:
		if i == 0:
			new_file.write(_str)
			break
		
new_file.write("\n")

for i in env_list:
	new_file.write(i + "\n")

if env_list != []:
	new_file.write("\n")

new_file.write("setup()\n{\n")

for i in virtual_list:
	new_file.write("\tiregister -s %s virtual\n" %(i))
	
for i in service_list:
	new_file.write("\tiregister -s %s service\n" %(i))

for i in daemon_list:
	new_file.write("\tiregister -s %s daemon\n" %(i))
	
new_file.write("\n")

for i in iset_list:
	if i in service_and_daemon_list:
		_service = i
	elif i.startswith("#"):
		new_file.write(i + "\n")
	else:
		new_file.write("\tiset -s %s %s\n" %(_service, i))

new_file.write("\n")

for i in iexec_list:
	if i in service_and_daemon_list:
		_service = i
	elif i == "%start%":
		new_file.write("\tiexec -s %s start = %s_start\n" %(_service, os.path.basename(_service)))
	elif i == "%stop%":
		new_file.write("\tiexec -s %s stop = %s_stop\n" %(_service, os.path.basename(_service)))
		
new_file.write("\n")

for i in service_and_daemon_list:
	new_file.write("\tidone -s %s\n" %(i))

new_file.write("}\n\n")

_mode = "0"
for i in iexec_list:
	if i in service_and_daemon_list:
		if _mode == "2":
			new_file.write("}\n\n")
		_service = i
		_mode = "1"
	elif i == "%start%":
		if _mode == "2":
			new_file.write("}\n\n")
		new_file.write("%s_start()\n{\n" %(os.path.basename(_service)))
		_mode = "2"
	elif i == "%stop%":
		if _mode == "2":
			new_file.write("}\n\n")
		new_file.write("%s_stop()\n{\n" %(os.path.basename(_service)))
		_mode = "2"
	else:
		new_file.write(i + "\n")
		
if _mode != "0":
	new_file.write("}\n\n")
	
new_file.close()
print scriptname.rstrip("i") + "ss" + " is ready.\n"




