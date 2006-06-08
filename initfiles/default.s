#!/sbin/runiscript

setup()
{
    iregister runlevel
	iset need = "clock getty initial udev"
	idone
}
