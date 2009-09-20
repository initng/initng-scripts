#!/bin/sh
[ -z "${BDIR}" ] && BDIR=build

die()
{
	echo "ERROR: ${*}."
	exit 1
}

ask()
{
	echo -n "${*} [n]? "
	read _answer
	[ "${_answer}" = "y" ]
}

echo "**** Creating the build directory ***"
if [ -d "${BDIR}" ]; then
	echo "WARNING: ${BDIR} already exists."
	ask "Do you want to continue" || exit 0
	rm -rf "${BDIR}"
fi
mkdir "${BDIR}"
cd "${BDIR}" || die "Can't create directory ${BDIR}"

echo "**** Configuring project ****"
cmake .. "$@" || die "Configuration failed"

echo "**** Compiling project ****"
make || die "Compilation failed"

echo "**** Installing project ****"
if ask "Do you want to install initng now"; then
	if [ ${UID} -eq 0 ]; then
		make install
	else	
		echo "root privileges required."
		su -c "make install"
	fi || die "Installation failed"
fi

cd ..
ask "Do you want to clear the build directory" &&
	rm -rf "${BDIR}"

exit 0
