# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	export SERVICE="daemon/sendmail/prepare"
	iregister service
	iset need = "system/bootmisc"
	iexec start = prepare_start
	idone

	export SERVICE="daemon/sendmail"
	iregister daemon
	iset need = "system/bootmisc virtual/net"
	iset use = "daemon/sendmail/prepare"
	iset provide = "virtual/mta"
	iset exec daemon = "@/usr/sbin/sendmail@ -q1h -bD"
	idone
}

prepare_start()
{
	if [ -x /usr/bin/make -a -f /etc/mail/Makefile ]
	then
		@make@ all -C /etc/mail -s >/dev/null
	else
		for i in virtusertable access domaintable mailertable
		do
			[ -f /etc/mail/${i} ] && @makemap@ hash /etc/mail/${i} </etc/mail/${i}
		done
	fi
	@/usr/bin/newaliases@ >/dev/null 2>&1
}
