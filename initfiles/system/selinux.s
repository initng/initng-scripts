# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service system/selinux/dev
	iset need = system/initial/mountvirtfs
	iexec start = dev_start
	idone

	ireg service system/selinux/relabel
	iset need = system/mountroot
	iexec start = relabel_start
	idone
}

dev_start()
{
	[ -x @/sbin/restorecon@ ] && @fgrep@ -q " /dev " /proc/mounts &&
		@/sbin/restorecon@ -R /dev 2>/dev/null
}

relabel_start()
{
	check_selinux() {
		while read dev mp fs stuff
		do
			[ "$fs" = "selinuxfs" ] && echo "$mp"
		done
	}

	# Check SELinux status
	#selinuxfs=`@awk@ '$3=="selinuxfs" {print $2}' /proc/mounts`
	#selinuxfs="`check_selinux`"
	#hardcode path for now
	#check_selinux seems to cause boot hangs
	selinuxfs="/selinux"
	SELINUX=

	if [ -n "${selinuxfs}" -a "`@cat@ /proc/self/attr/current`" != "kernel" ]
	then
		if [ -r ${selinuxfs}/enforce ]
		then
			SELINUX=`@cat@ ${selinuxfs}/enforce`
		else
			# assume enforcing if you can't read it
			SELINUX=1
		fi
	fi

	relabel_selinux() {
		echo
		echo '*** Warning -- SELinux relabel is required. ***'
		echo '*** Disabling security enforcement.         ***'
		echo '*** Relabeling could take a very long time, ***'
		echo '*** depending on file system size.          ***'
		echo
		echo "0" > ${selinuxfs}/enforce
		@/sbin/fixfiles@ restore >/dev/null 2>&1
		@/bin/rm@ -f /.autorelabel
		echo '*** Enabling security enforcement.          ***'
		echo ${SELINUX} >${selinuxfs}/enforce
	}

	# Check to see if a full relabel is needed
	if [ -n "${SELINUX}" ]
	then
		[ -f /.autorelabel ] || echo "${cmdline}" | @grep@ -q autorelabel &&
			relabel_selinux
	else
		[ -d /etc/selinux ] && [ -f /.autorelabel ] ||
			@touch@ /.autorelabel
	fi
}
