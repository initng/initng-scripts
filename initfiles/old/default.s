#!/sbin/runiscript

setup()
{
    iregister runlevel
	iset need = "clock getty initial udev hostname net/lo keymaps acpid dbus hald speedstep"
	idone
}
