#!/sbin/runiscript

setup()
{
    iregister runlevel
	iset need = "test up-fake"
	idone
}
