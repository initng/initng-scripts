# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister -s "daemon/sendmail/prepare" service
	iregister -s "daemon/sendmail" daemon

	iset -s "daemon/sendmail/prepare" need = "system/bootmisc"
	iset -s "daemon/sendmail" need = "system/bootmisc virtual/net"
	iset -s "daemon/sendmail" use = "daemon/sendmail/prepare"
	iset -s "daemon/sendmail" provide = "virtual/mta"

	iexec -s "daemon/sendmail/prepare" start = prepare_start
	iexec -s "daemon/sendmail" daemon = "@/usr/sbin/sendmail@ -q1h -bD"

	idone -s "daemon/sendmail/prepare"
	idone -s "daemon/sendmail"
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
