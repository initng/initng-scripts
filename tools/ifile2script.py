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
script_list = []
env_list_mode = 0
env_list_mode_1 = 0
iexec_list_mode = 0
iexec_list_mode_1 = 0
iset_list_mode = 0
iset_list_mode_1 = 0
script_list_mode = 0
script_list_mode_1 = 0
iregister_list_mode = 0
iregister_list_mode_1 = 0
ifd_mode = 0
elsed_mode = 0
ifd_list = []
file_mode = "0"

for i in file_list:
	
	if i.startswith("#ifd"):
			ifd_mode = ifd_mode + 1
			elsed_mode = i.strip()
			ifd_list.insert(0, i.strip())
			elsed_mode = len(ifd_list)

	elif i.startswith("#elsed"):
			elsed_mode = i.strip()
			ifd_list.insert(0, i.strip())
			elsed_mode = len(ifd_list)

	elif i.startswith("#endd"):
			ifd_mode = ifd_mode - 1
			for g in range(len(ifd_list)):
				if ifd_list[g].startswith("#ifd"):
					ifd_list = ifd_list[g + 1:]
					if ifd_list == []:
						elsed_mode = 0
					else:
						if len(ifd_list) == 1:
							elsed_mode = 1
						else:
							elsed_mode = len(ifd_list)
					break

			if env_list_mode != 0 and env_list_mode_1 == ifd_mode + 1:
				env_list.append("#endd")
				env_list_mode = elsed_mode
				env_list_mode_1 = env_list_mode_1 - 1
			if iset_list_mode != 0 and iset_list_mode_1 == ifd_mode + 1:
				iset_list.append("#endd")
				iset_list_mode = elsed_mode
				iset_list_mode_1 = iset_list_mode_1 - 1
			if iexec_list_mode != 0 and iexec_list_mode_1 == ifd_mode + 1:
				iexec_list.append("#endd")
				iexec_list_mode = elsed_mode
				iexec_list_mode_1 = iexec_list_mode_1 - 1
			if script_list_mode != 0 and script_list_mode_1 == ifd_mode + 1:
				script_list.append("#endd")
				script_list_mode = elsed_mode
				script_list_mode_1 = script_list_mode_1 - 1
			if iregister_list_mode != 0 and iregister_list_mode_1 == ifd_mode + 1:
				iregister_list.append("#endd")
				iregister_list_mode = elsed_mode
				iregister_list_mode_1 = iregister_list_mode_1 - 1
				
	elif i.startswith("service"):
		_service = i.split()[1].strip("{").strip()
		iset_list.append(_service)
		service_and_daemon_list.append(_service)
		if iset_list_mode != elsed_mode and elsed_mode != 0:
				for g in range(-1 - iset_list_mode, -1 - len(ifd_list), -1):
					iset_list.append(ifd_list[g])
					if ifd_list[g].startswith("#ifd"):
						iset_list_mode_1 = iset_list_mode_1 + 1
				iset_list_mode = elsed_mode
		
		if iregister_list_mode != elsed_mode and elsed_mode != 0:
				for g in range(-1 - iregister_list_mode, -1 - len(ifd_list), -1):
					iregister_list.append(ifd_list[g])
					if ifd_list[g].startswith("#ifd"):
						iregister_list_mode_1 = iregister_list_mode_1 + 1
				iregister_list_mode = elsed_mode
		
		file_mode = "1"
		iregister_list.append(_service)
		iregister_list.append("service")
		
	elif i.startswith("daemon"):
		_service = i.split()[1].strip("{").strip()
		iset_list.append(_service)
		service_and_daemon_list.append(_service)
		if iset_list_mode != elsed_mode and elsed_mode != 0:
				for g in range(-1 - iset_list_mode, -1 - len(ifd_list), -1):
					iset_list.append(ifd_list[g])
					if ifd_list[g].startswith("#ifd"):
						iset_list_mode_1 = iset_list_mode_1 + 1
				iset_list_mode = elsed_mode
		
		if iregister_list_mode != elsed_mode and elsed_mode != 0:
				for g in range(-1 - iregister_list_mode, -1 - len(ifd_list), -1):
					iregister_list.append(ifd_list[g])
					if ifd_list[g].startswith("#ifd"):
						iregister_list_mode_1 = iregister_list_mode_1 + 1
				iregister_list_mode = elsed_mode
		
		iregister_list.append(_service)
		iregister_list.append("daemon")
		file_mode = "1"

	elif i.startswith("virtual"):
		_service = i.split()[1].strip("{").strip()
		iset_list.append(_service)
		service_and_daemon_list.append(_service)
		if iset_list_mode != elsed_mode and elsed_mode != 0:
				for g in range(-1 - iset_list_mode, -1 - len(ifd_list), -1):
					iset_list.append(ifd_list[g])
					if ifd_list[g].startswith("#ifd"):
						iset_list_mode_1 = iset_list_mode_1 + 1
				iset_list_mode = elsed_mode
		
		if iregister_list_mode != elsed_mode and elsed_mode != 0:
				for g in range(-1 - iregister_list_mode, -1 - len(ifd_list), -1):
					iregister_list.append(ifd_list[g])
					if ifd_list[g].startswith("#ifd"):
						iregister_list_mode_1 = iregister_list_mode_1 + 1
				iregister_list_mode = elsed_mode
				
		iregister_list.append(_service)
		iregister_list.append("virtual")
		file_mode = "1"

	elif file_mode == "1":
		i = i.strip(" \t")
		if i.startswith("script"):
			file_mode = "2"
			if iexec_list_mode != elsed_mode and elsed_mode != 0:
				for g in range(-1 - iexec_list_mode, -1 - len(ifd_list), -1):
					iexec_list.append("%" + ifd_list[g])
					if ifd_list[g].startswith("#ifd"):
						iexec_list_mode_1 = iexec_list_mode_1 + 1
				iexec_list_mode = elsed_mode
			iexec_list.append(_service)
			iexec_list.append("%" + i.split()[1].strip())
			
			if script_list_mode != elsed_mode and elsed_mode != 0:
				for g in range(-1 - script_list_mode, -1 - len(ifd_list), -1):
					script_list.append("%" + ifd_list[g])
					if ifd_list[g].startswith("#ifd"):
						script_list_mode_1 = script_list_mode_1 + 1
				script_list_mode = elsed_mode
			script_list.append(_service)
			script_list.append("%" + i.split()[1].strip())
			
		elif i.startswith("env"):
			if i.startswith("env_file"):
				_str = "source " + i.split("=", 1)[1].strip(" ;")
			else:
				_str = i.split(" ", 1)[1].strip(" ;")
				_str = _str.split("=")[0] + '="'+ _str.split("=")[1] + '"'
		
			if env_list_mode != elsed_mode and elsed_mode != 0:
				for g in range(-1 - env_list_mode, -1 - len(ifd_list), -1):
					env_list.append(ifd_list[g])
					if ifd_list[g].startswith("#ifd"):
						env_list_mode_1 = env_list_mode_1 + 1
				env_list_mode = elsed_mode
			env_list.append(_str)

		elif "=" in i:
			str_0 = i.split("=")[0].strip()
			str_1 = i.split("=")[-1].strip(" ;")
			
			if iset_list_mode != elsed_mode and elsed_mode != 0:
				for g in range(-1 - iset_list_mode, -1 - len(ifd_list), -1):
					iset_list.append(ifd_list[g])
					if ifd_list[g].startswith("#ifd"):
						iset_list_mode_1 = iset_list_mode_1 + 1
				iset_list_mode = elsed_mode
			iset_list.append(str_0 + ' = "' + str_1 + '"')
			
		elif i != "" and i != "}" and not i.startswith("#"):
			if "#" in i:
				_int = i.find("#")
				i = i[:_int]
			iset_list.append(i.strip(" ;"))

	elif file_mode == "2":
		_str = i.strip(" \t")
		if _str == "};":
			file_mode = "1"
			script_list.append("}")
		else:
			
			if script_list_mode != elsed_mode and elsed_mode != 0:
				for g in range(-1 - script_list_mode, -1 - len(ifd_list), -1):
					script_list.append("%" + ifd_list[g])
					if ifd_list[g].startswith("#ifd"):
						script_list_mode_1 = script_list_mode_1 + 1
				script_list_mode = elsed_mode
			
			script_list.append(i)


new_file = open(os.getcwd() + "/" + scriptname.rstrip("i") + "s", "w")

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

len_service_and_daemon_list = len(service_and_daemon_list)

for i in iregister_list:
	if i.startswith("#"):
		new_file.write("%s\n" %(i))
	elif i in service_and_daemon_list:
		if len_service_and_daemon_list == 1:
			new_file.write("\tiregister %s\n" %(iregister_list[iregister_list.index(i) + 1].lstrip("%")))
		else:
			new_file.write("\tiregister -s \"%s\" %s\n" %(i, iregister_list[iregister_list.index(i) + 1].lstrip("%")))

new_file.write("\n")

for i in iset_list:
	if i in service_and_daemon_list:
		_service = i
	elif i.startswith("#"):
		new_file.write(i + "\n")
	elif not i.startswith("%"):
		if len_service_and_daemon_list == 1:
			new_file.write("\tiset %s\n" %(i))
		else:
			new_file.write("\tiset -s \"%s\" %s\n" %(_service, i))

new_file.write("\n")

for i in iexec_list:
	if i.startswith("%#"):
		new_file.write("%s\n" %(i.lstrip("%")))

	elif i.startswith("%"):
		_func = i.lstrip("%")
		_func_prefix = _service
		if _func_prefix.endswith("*"):
			_func_prefix = _func_prefix.replace("/*","_any")
		if len_service_and_daemon_list == 1:
			new_file.write("\tiexec %s = %s_%s\n" %(_func, os.path.basename(_func_prefix), _func))
		else:
			new_file.write("\tiexec -s \"%s\" %s = %s_%s\n" %(_service, _func, os.path.basename(_func_prefix), _func))
	elif i.startswith("&"):
		if len_service_and_daemon_list == 1:
			new_file.write("\tiexec %s\n" %(i.lstrip("&")))
		else:
			new_file.write("\tiexec -s \"%s\" %s\n" %(_service, i.lstrip("&")))
	elif i.startswith("#"):
		new_file.write(i + "\n")
	elif i in service_and_daemon_list:
		_service = i

new_file.write("\n")

for i in iregister_list:
	if i.startswith("#"):
		new_file.write("%s\n" %(i))
	elif i in service_and_daemon_list:
		if len_service_and_daemon_list == 1:
			new_file.write("\tidone\n")
		else:
			new_file.write("\tidone -s \"%s\"\n" %(i))

new_file.write("}\n")

_mode = "0"
for i in script_list:
	if i in service_and_daemon_list:
		if _mode == "2" or _mode == "0":
			new_file.write("\n")
		_service = i
		_mode = "1"
	
	elif i.startswith("%#"):
		new_file.write("%s\n" %(i.lstrip("%")))
	
	elif i.startswith("%"):
		if _mode == "2":
			new_file.write("\n")

		_func_prefix = _service
		if _func_prefix.endswith("*"):
			_func_prefix = _func_prefix.replace("/*","_any")

		new_file.write("%s_%s()\n{\n" %(os.path.basename(_func_prefix), i.strip("%")))
		_mode = "2"
	elif i.startswith("&"):
		if _mode == "2":
			new_file.write("\n")
		_mode = "0"
	else:
		new_file.write(i + "\n")

new_file.close()
print scriptname.rstrip("i") + "s" + " is ready.\n"

