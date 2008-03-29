# SERVICE: system/initial
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister virtual
		iset critical
		iset need = system/initial/loglevel \
		            system/initial/mountvirtfs system/initial/filldev
		iset use = system/selinux/dev system/udev
	idone
}
