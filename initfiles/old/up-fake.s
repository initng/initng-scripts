#!/sbin/runiscript

setup()
{
	# register new service type, the $SERVICE will be "example" here.
    iregister service

	iset last
	iset exec start = "echo Up plugin works!"

	# Tell initng this service is done parsing.
    idone
}
