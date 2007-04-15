# NAME:
# DESCRIPTION:
# WWW:

#ifd pingwinek
distro="Pingwinek"
#elsed debian
distro="Debian"
#elsed gentoo
distro="Gentoo"
#elsed fedora
distro="Fedora"
#elsed lfs
distro="LinuxFromScratch"
#elsed mandriva
distro="Mandriva"
#elsed
distro="Unknown distro"
#endd

setup()
{
	ireg service service/issue && {
		iset need = system/initial system/mountroot
		iexec start
	}
}

start()
{
	arch=`@uname@ -m`
	a="a"
	case "${arch}" in
		_a*) a="an" ;;
		_i*) a="an" ;;
	esac
	NUMPROC=`@egrep@ -c "^cpu[0-9]+" /proc/stat`
	if [ "${NUMPROC}" -gt "1" ]
	then
		SMP="${NUMPROC}-processor "
		[ "${NUMPROC}" = "2" ] && SMP="Dual-processor "
		[ "${NUMPROC}" = "8" -o "${NUMPROC}" = "11" ] && a=an || a=a
	fi

	cat <<EOF >/etc/issue
${distro}
Kernel `@uname@ -r` on ${a} ${SMP}`@uname@ -m` (\l)
Powered by initng, written by Jimmy Wennlund <jimmy.wennlund@gmail.com>"
EOF

	cat <<EOF >/etc/issue.net
${distro}
Kernel `@uname@ -r` on ${a} ${SMP}`@uname@ -m`
Powered by initng, written by Jimmy Wennlund <jimmy.wennlund@gmail.com>"
EOF
}
