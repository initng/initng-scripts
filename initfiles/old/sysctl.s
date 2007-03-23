#!/sbin/runiscript

setup()
{
    iregister service
    iset need = "initial"
	iset exec start = "@/sbin/sysctl@ -n -e -q -p"
    idone
}
