# NAME: xfs
# DESCRIPTION: The X font server
# WWW: http://xorg.freedesktop.org

#ifd gentoo
XFS_PORT="-1"
source /etc/conf.d/xfs
#endd

setup()
{
	export SERVICE="daemon/xfs/chkfontpath"
	iregister service
	iset need = "system/bootmisc"
	iexec start = chkfontpath
	idone

	export SERVICE="daemon/xfs"
	iregister daemon
#ifd gentoo
	iset need = "system/bootmisc"
#elsed
	iset need = "system/bootmisc daemon/xfs/chkfontpath"
#endd
#ifd debian
	iset exec daemon = "@/usr/X11R6/bin/xfs@ -droppriv -nodaemon"
#elsed gentoo
	iexec daemon
#elsed
	iset exec daemon = "@/usr/bin/xfs@ -droppriv -nodaemon"
#endd
	idone
}
#ifd gentoo

daemon()
{
	exec @/usr/bin/xfs@ -nodaemon -config /etc/X11/fs/config -droppriv \
	                    -user xfs -port ${XFS_PORT}
}
#endd

chkfontpath()
{
	umask 133

	if [ -x @/usr/sbin/chkfontpath@ ]
	then
		# chkfontpath output filtering, strips all of the junk output by
		# chkfontpath that we do not want, including headers, FPE numbers and
		# whitespace and other junk.  Also filters out FPE's with trailing
		# modifiers such as ":unscaled" et al.
		for dir in `@/usr/sbin/chkfontpath@ --list | @sed@ -e '/^Current/d;s#^[0-9]*: ##g;s#^/.*:[a-z]*$##g;/^[[:space:]]*$/d' | @sort@ -u`
		do
			if [ -d "${dir}" ]
			then
				cd "${dir}"
				# If fonts.dir does not exist, or if there are files in the
				# directory with a newer change time, regenerate fonts.dir, etc.
				# Using "-cnewer" here fixes bug #53737
				if [ ! -e fonts.dir -o -n "`@find@ . -maxdepth 1 -type f -cnewer fonts.dir -not -name 'fonts.cache*'`" ]
				then
					@rm@ -f fonts.dir
					if @ls@ | @grep@ -iqs '\.ot[cf]$'
					then
						# Opentype fonts found, generate fonts.scale and fonts.dir
						@/usr/bin/mkfontscale@ . && @/usr/bin/mkfontdir@ . >/dev/null 2>&1
					elif @ls@ | @grep@ -iqs '\.tt[cf]$'
					then
						# TrueType fonts found, generate fonts.scale and fonts.dir
						@/usr/bin/ttmkfdir@ -d . -o fonts.scale && @/usr/bin/mkfontdir@ . >/dev/null 2>&1
					elif @ls@ | @grep@ -Eiqsv '(^fonts\.(scale|alias|cache.*)$|.+(\.[ot]t[cf]|dir)$)'
					then
						# This directory contains non-TrueType/non-Opentype fonts
						@/usr/bin/mkfontdir@ . >/dev/null 2>&1
					fi
				fi
			fi
		done
	fi
	# Now we run fc-cache, assuming fonts may have been added, without
	# explicitly checking, as it is rather fast anyway.  Some older versions
	# of fc-cache will SEGV, which is prevented by invoking it with HOME=/
	[ -x "/usr/bin/fc-cache" ] && HOME=/ "/usr/bin/fc-cache"

	FONT_UNIX_DIR=/tmp/.font-unix
	# Clean out .font-unix dir, and recreate it with the proper ownership and
	# permissions.
	@rm@ -rf ${FONT_UNIX_DIR}
	@mkdir@ ${FONT_UNIX_DIR}
	@chown@ root:root ${FONT_UNIX_DIR}
	@chmod@ 1777 ${FONT_UNIX_DIR}
}
